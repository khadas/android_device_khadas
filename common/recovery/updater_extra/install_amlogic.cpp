/*
 * Copyright (C) 2009 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <ctype.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <selinux/selinux.h>
#include <ftw.h>
#include <sys/capability.h>
#include <sys/xattr.h>
#include <linux/xattr.h>
#include <inttypes.h>

#include <memory>
#include <vector>

#include "bootloader.h"
#include "cutils/android_reboot.h"
#include "cutils/properties.h"
#include "edify/expr.h"
#include "error_code.h"
#include "updater/updater.h"
extern "C" {
#include "ubootenv/uboot_env.h"
#include "check/dtbcheck.h"
}
#include "roots.h"
#include <bootloader_message/bootloader_message.h>
#include <fs_mgr.h>


#define ARRAY_SIZE(x)  sizeof(x)/sizeof(x[0])
#define EMMC_USER_PARTITION        "bootloader"
#define EMMC_BLK0BOOT0_PARTITION   "mmcblk0boot0"
#define EMMC_BLK0BOOT1_PARTITION   "mmcblk0boot1"
#define EMMC_BLK1BOOT0_PARTITION   "mmcblk1boot0"
#define EMMC_BLK1BOOT1_PARTITION   "mmcblk1boot1"
#define COMMAND_FILE "/cache/recovery/command"
#define CACHE_ROOT "/cache"


enum emmcPartition {
    USER = 0,
    BLK0BOOT0,
    BLK0BOOT1,
    BLK1BOOT0,
    BLK1BOOT1,
};

static int sEmmcPartionIndex = -1;
static const char *sEmmcPartionName[] = {
    EMMC_USER_PARTITION,
    EMMC_BLK0BOOT0_PARTITION,
    EMMC_BLK0BOOT1_PARTITION,
    EMMC_BLK1BOOT0_PARTITION,
    EMMC_BLK1BOOT1_PARTITION,
};
extern "C" {
int RecoverySecureCheck(const ZipArchive zipArchive);
int RecoveryDtbCheck(const ZipArchive zipArchive);
}
/*
 * return value: 0 if no error; 1 if path not existed, -1 if access failed
 *
 */
static int read_sysfs_val(const char* path, char* rBuf, const unsigned bufSz, int * readCnt)
{
        int ret = 0;
        int fd  = -1;
        int count = 0;

        if (access(path, F_OK)) {
                printf("path[%s] not existed\n", path);
                return 1;
        }
        if (access(path, R_OK)) {
                printf("path[%s] cannot read\n", path);
                return -1;
        }

        fd = open(path, O_RDONLY);
        if (fd <= 0) {
                printf("fail in open[%s] in O_RDONLY\n", path);
                goto _exit;
        }

        count = read(fd, rBuf, bufSz);
        if (count <= 0) {
                printf("read %s failed (count:%d)\n",
                                path, count);
                close(fd);
                return -1;
        }
        *readCnt = count;

        ret = 0;
_exit:
        if (fd > 0) close(fd);
        return ret;
}

static int getBootloaderOffset(int* bootloaderOffset)
{
        const char* PathBlOff = "/sys/class/aml_store/bl_off_bytes" ;
        int             iret  = 0;
        int             blOff = 0;
        char  buf[16]         = { 0 };
        int           readCnt = 0;

        iret = read_sysfs_val(PathBlOff, buf, 16, &readCnt);
        if (iret < 0) {
                printf("fail when read path[%s]\n", PathBlOff);
                return __LINE__;
        }
        buf[readCnt] = 0;
        *bootloaderOffset = atoi(buf);
        printf("bootloaderOffset is %s\n", buf);

        return 0;
}

static int _mmcblOffBytes = 0;


static int write_data(int ctx, const char *data, ssize_t len)
{
    size_t wrote = len;
    int fd = ctx;
    ssize_t size = len;
    off_t pos = lseek(fd, 0, SEEK_CUR);
    fprintf(stderr, "data len = %d, pos = %ld\n", len, pos);
    char *verify = NULL;
    if (/*lseek(fd, pos, SEEK_SET) != pos ||*/
        write(fd, data, len) != len) {
        fprintf(stderr, " write error at 0x%08lx (%s)\n",
        pos, strerror(errno));
    }

    verify = (char *)malloc(size);
    if (verify == NULL) {
        fprintf(stderr, "block: failed to malloc size=%u (%s)\n", size, strerror(errno));
        return -1;
    }

    if (lseek(fd, pos, SEEK_SET) != pos ||
        read(fd, verify, size) != size) {
        fprintf(stderr, "block: re-read error at 0x%08lx (%s)\n",
        pos, strerror(errno));
        if (verify)
        free(verify);
        return -1;
    }

    if (memcmp(data, verify, size) != 0) {
        fprintf(stderr, "block: verification error at 0x%08lx (%s)\n",
        pos, strerror(errno));
        if (verify)
        free(verify);
        return -1;
    }

    fprintf(stderr, " successfully wrote data at %ld\n", pos);
    if (verify) {
        free(verify);
    }

    return wrote;
}


//return value
// -1  :   failed
//  0   :   success
static int backup_partition_data(const char *name,const char *dir, long offset) {
    int ret = 0;
    int fd = 0;
    FILE *fp = NULL;
    int sor_fd = -1;
    int dst_fd = -1;
    ssize_t wrote = 0;
    ssize_t readed = 0;
    char devpath[128] = {0};
    char dstpath[128] = {0};
    const int BUFFER_MAX =  32*1024*1024;   //Max support 32*M
    printf("backup partition name:%s, to dir:%s\n", name, dir);

    if ((name == NULL) || (dir == NULL)) {
        fprintf(stderr, "name(%s) or dir(%s) is NULL!\n", name, dir);
        return -1;
    }

    if (!strcmp(name, "dtb")) {//dtb is char device
        sprintf(devpath, "/dev/%s", name);
    } else {
        sprintf(devpath, "/dev/block/%s", name);
    }

    sprintf(dstpath, "%s%s.img", dir, name);

    sor_fd = open(devpath, O_RDONLY);
    if (sor_fd < 0) {
        fprintf(stderr, "open %s failed (%s)\n",devpath, strerror(errno));
        return -1;
    }

    dst_fd = open(dstpath, O_WRONLY | O_CREAT, 00777);
    if (dst_fd < 0) {
        fprintf(stderr, "open %s failed (%s)\n",dstpath, strerror(errno));
        return -1;
    }

    char* buffer = (char *)malloc(BUFFER_MAX);
    if (buffer == NULL) {
        fprintf(stderr, "can't malloc %d buffer!\n", BUFFER_MAX);
        goto err_out;
    }

    if (strcmp(name, "dtb")) {
        lseek(sor_fd, offset, SEEK_SET);
    }

    readed = read(sor_fd, buffer, BUFFER_MAX);
    if (readed <= 0) {
        fprintf(stderr, "read failed read:%d!\n", readed);
        goto err_out;
    }

    wrote = write(dst_fd, buffer, readed);
    if (wrote != readed) {
        fprintf(stderr, "write %s failed (%s)\n",dstpath, strerror(errno));
        goto err_out;
    }

    close(dst_fd);
    close(sor_fd);
    free(buffer);
    buffer == NULL;

    //umount /cache and do fsync for data save
    ret = umount("/cache");
    if (ret != 0) {
        fprintf(stderr, "umount cache failed (%s)\n",dstpath, strerror(errno));
    }

    fd = open("/dev/block/cache", O_RDWR);
    if (fd < 0) {
        fprintf(stderr, "open %s failed (%s)\n","/dev/block/cache", strerror(errno));
        return -1;
    }

    fp = fdopen(fd, "r+");
    if (fp == NULL) {
        printf("fdopen failed!\n");
        close(fd);
        return -1;
    }

    fflush(fp);
    fsync(fd);
    fclose(fp);

    ret = mount("/dev/block/cache", "/cache", "ext4",\
        MS_NOATIME | MS_NODEV | MS_NODIRATIME,"discard");
    if (ret < 0 ) {
        fprintf(stderr, "mount cache failed (%s)\n","/dev/block/cache", strerror(errno));
    }

    return 0;


err_out:
    if (sor_fd > 0) {
        close(sor_fd);
    }

    if (dst_fd > 0) {
        close(dst_fd);
    }

    if (buffer) {
        free(buffer);
        buffer == NULL;
    }

    return -1;

}


static int write_chrdev_data(
    const char *dev, const char *data, ssize_t size)
{
    int fd = -1;
    ssize_t wrote = 0;
    ssize_t readed = 0;
    char *verify = NULL;

    fd = open(dev, O_RDWR);
    if (fd < 0) {
        fprintf(stderr, "open %s failed (%s)\n",
            dev, strerror(errno));
        return -1;
    }

    fprintf(stderr, "data len = %d\n", size);
    if ((wrote = write(fd, data, size)) != size) {
        fprintf(stderr, "wrote error, count %d (%s)\n",
            wrote, strerror(errno));
        goto err;
    }

    close(fd);
    fd = open(dev, O_RDWR);
    if (fd < 0) {
        fprintf(stderr, "open %s failed after wrote success (%s)\n",
            dev, strerror(errno));
        return -1;
    }

    verify = (char *)malloc(size);
    if (verify == NULL) {
        fprintf(stderr, "failed to malloc size=%d (%s)\n",
            size, strerror(errno));
        goto err;
    }

    if ((readed = read(fd, verify, size)) != size) {
        fprintf(stderr, "readed error, count %d (%s)\n",
            readed, strerror(errno));
        if (verify != NULL) {
            free(verify);
        }
        goto err;
    }

    if (memcmp(data, verify, size) != 0) {
        fprintf(stderr, "verification error, wrote != readed\n");
        if (verify != NULL) {
            free(verify);
        }
        goto err;
    }

    fprintf(stderr, " successfully wrote data\n");
    if (verify != NULL) {
        free(verify);
    }

    if (fd > 0) {
        close(fd);
    }
    return wrote;

err:
    if (fd > 0) {
        close(fd);
    }
    return -1;
}


//Ignore mbr since mmc driver already handled
//#define MMC_UBOOT_CLEAR_MBR

char *block_write_data( Value* contents, char * name, unsigned long int offset)
{
    char devname[64] = {0};
    int fd = -1;
    int check = 0;
    char * tmp_name = NULL;
    char *result = NULL;
    bool success = false;

    sprintf(devname, "/dev/block/%s", name);
    if (!strncmp(name, "bootloader", strlen("bootloader"))) {
        memset(devname, 0, sizeof(devname));
        sprintf(devname, "/dev/%s", name);  //nand partition
        fd = open(devname, O_RDWR);
        if (fd < 0) {
            memset(devname, 0, sizeof(devname));
            // emmc user, boot0, boot1 partition
            sprintf(devname, "/dev/block/%s", sEmmcPartionName[sEmmcPartionIndex]);
            fd = open(devname, O_RDWR);
            if (fd < 0) {
                tmp_name = "mtdblock0";
                memset(devname, 0, sizeof(devname));
                sprintf(devname, "/dev/block/%s", tmp_name); //spi partition
                fd = open(devname, O_RDWR);
                if (fd < 0) {
                    printf("failed to open %s\n", devname);
                    result = strdup("");
                    goto done;
                }
            }

            printf("start to write %s to %s...\n", name, devname);
#ifdef MMC_UBOOT_CLEAR_MBR
            //modify the 55 AA info for emmc uboot
            contents->data[510] = 0;
            contents->data[511] = 0;
            printf("modify the 55 AA info for emmc uboot\n");
#endif

            lseek(fd, offset, SEEK_SET);//seek to skip mmc area since gxl

            if (contents->type == VAL_STRING) {
                printf("%s contents type: VAL_STRING\n", name);
                char* filename = contents->data;
                FILE* f = fopen(filename, "rb");
                if (f == NULL) {
                    fprintf(stderr, "%s: can't open %s: %s\n", name, filename, strerror(errno));
                    result = strdup("");
                    goto done;
                }

                success = true;
                char* buffer = (char *)malloc(BUFSIZ);
                if (buffer == NULL) {
                    fprintf(stderr, "can't malloc (%s)\n", strerror(errno));
                    result = strdup("");
                    goto done;
                }
                int read;
                while (success && (read = fread(buffer, 1, BUFSIZ, f)) > 0) {
                    int wrote = write_data(fd, buffer, read);
                    success = success && (wrote == read);
                }
                free(buffer);
                fclose(f);
            } else {
                printf("%s contents type: VAL_BLOB\n", name);
                lseek(fd, offset, SEEK_SET);//seek to skip mmc area since gxl
                ssize_t wrote = write_data(fd, contents->data, contents->size);
                success = (wrote == contents->size);
            }

            if (!success) {
                fprintf(stderr, "write_data to %s partition failed: %s\n", devname, strerror(errno));
            } else {
                printf("write_data to %s partition successful\n", devname);
            }
        } else {
            printf("start to write %s to %s...\n", name, devname);

            lseek(fd, offset, SEEK_SET);//seek to skip mmc area since gxl
            success = true;
            size_t len =  contents->size;
            fprintf(stderr, "data len = %d\n", len);
            int size =  contents->size;
            off_t pos = lseek(fd, offset, SEEK_SET);//need seek one sector to skip MBR area since gxl
            /*fprintf(stderr, "data len = %d pos = %d\n", len, pos);*/
            if (/*lseek(fd, pos, SEEK_SET) != pos ||*/write(fd, contents->data, size) != size) {
                fprintf(stderr, " write error at 0x%08lx (%s)\n",pos, strerror(errno));
                success = false;
            }

            if (!success) {
                fprintf(stderr, "write_data to %s partition failed: %s\n", devname, strerror(errno));
            } else {
                printf("write_data to %s partition successful\n", devname);
            }
        }
    } else {
        fd = open(devname, O_RDWR);
        if (fd < 0) {
            printf("failed to open %s\n", devname);
            result = strdup("");
            goto done;
        }

        printf("start to write %s to %s...\n", name, devname);
        if (contents->type == VAL_STRING) {
            printf("%s contents type: VAL_STRING\n", name);
            char* filename = contents->data;
            FILE* f = fopen(filename, "rb");
            if (f == NULL) {
                fprintf(stderr, "%s: can't open %s: %s\n", name, filename, strerror(errno));
                result = strdup("");
                goto done;
            }

            success = true;
            char* buffer = (char *)malloc(BUFSIZ);
            if (buffer == NULL) {
                fprintf(stderr, "can't malloc (%s)\n", strerror(errno));
                result = strdup("");
                goto done;
            }
            int read;
            while (success && (read = fread(buffer, 1, BUFSIZ, f)) > 0) {
                lseek(fd, offset, SEEK_SET);
                int wrote = write_data(fd, buffer, read);
                success = success && (wrote == read);
            }
            free(buffer);
            fclose(f);
        } else {
            printf("%s contents type: VAL_BLOB\n", name);
            lseek(fd, offset, SEEK_SET);
            ssize_t wrote = write_data(fd, contents->data, contents->size);
            success = (wrote == contents->size);
        }

        if (!success) {
            fprintf(stderr, "write_data to %s partition failed: %s\n", devname, strerror(errno));
        } else {
            printf("write_data to %s partition successful\n", devname);
        }
    }

    result = success ? name : strdup("");

done:
    if (fd > 0) {
        close(fd);
        fd = -1;
    }
    return result;
}

Value* WriteBootloaderImageFn(const char* name, State* state, int argc, Expr* argv[]) {
    char* result = NULL;
    int iRet = 0;

    Value* partition_value;
    Value* contents;
    if (ReadValueArgs(state, argv, 2, &contents, &partition_value) < 0) {
        return NULL;
    }

    char* partition = NULL;
    if (partition_value->type != VAL_STRING) {
        ErrorAbort(state, kArgsParsingFailure, "partition argument to %s must be string", name);
        goto done;
    }
    partition = partition_value->data;
    if (strlen(partition) == 0) {
        ErrorAbort(state, kArgsParsingFailure, "partition argument to %s can't be empty", name);
        goto done;
    }
    if (contents->type == VAL_STRING && strlen((char*) contents->data) == 0) {
            ErrorAbort(state, kArgsParsingFailure, "file argument to %s can't be empty", name);
            goto done;
    }

    iRet = getBootloaderOffset(&_mmcblOffBytes);
    if (iRet) {
        printf("Fail in getBootloaderOffset, ret=%d\n", iRet);
        result = strdup("bootloader err");
        goto done;
    }

    sEmmcPartionIndex = USER;
    result = block_write_data(contents, partition, _mmcblOffBytes);
    if (!strcmp(result, partition)) {
        printf("Write Uboot Image successful!\n\n");
    } else {
        printf("Write Uboot Image failed!\n\n");
        printf("%s != %s, exit !!!\n", result, partition);
        goto done;
    }

    unsigned int i;
    char emmcPartitionPath[128];
    for (i = BLK0BOOT0; i < ARRAY_SIZE(sEmmcPartionName); i ++) {
        memset(emmcPartitionPath, 0, sizeof(emmcPartitionPath));
        sprintf(emmcPartitionPath, "/dev/block/%s", sEmmcPartionName[i]);
        if (!access(emmcPartitionPath, F_OK)) {
            sEmmcPartionIndex = i;
            result = block_write_data(contents, partition, _mmcblOffBytes);
            if (!strcmp(result, partition)) {
                printf("Write Uboot Image to %s successful!\n\n", sEmmcPartionName[sEmmcPartionIndex]);
            } else {
                printf("Write Uboot Image to %s failed!\n\n", sEmmcPartionName[sEmmcPartionIndex]);
                printf("%s != %s, exit !!!\n", result, partition);
                goto done;
            }
        }
    }

done:
    if (result != partition) FreeValue(partition_value);
    FreeValue(contents);
    return StringValue(result);
}

Value* WriteDtbImageFn(const char* name, State* state, int argc, Expr* argv[]) {
    char* result = NULL;
    bool success = false;
    Value* contents = NULL;

    if (ReadValueArgs(state, argv, 1, &contents) < 0) {
        fprintf(stderr, "%s: ReadValueArgs failed (%s)\n",
            name, strerror(errno));
        return NULL;
    }

    const char *DTB_DEV=  "/dev/dtb";
    // write 256K dtb datas to dtb device maximum,kernel limit
    const int DTB_DATA_MAX =  256*1024;
    printf("\nstart to write dtb.img to %s...\n", DTB_DEV);

    if (contents->type == VAL_BLOB) {
        printf("contents type: VAL_BLOB\ncontents size: %d\n",
            contents->size);
        if (!contents->data || -1 == contents->size) {
            printf("#ERR:BLOb Data extracted FAILED for dtb\n");
            success = 0;
        } else {
            if (contents->size > DTB_DATA_MAX) {
                fprintf(stderr, "data size(%d) out of range size(max:%d)\n",
                    contents->size, DTB_DATA_MAX);
                result = strdup("");
                goto done;
            }
            ssize_t wrote = write_chrdev_data(
                DTB_DEV, contents->data, contents->size);
            success = (wrote == contents->size);
        }
    } else {
        printf("contents type: VAL_STRING\ncontents size: %d\n",
            contents->size);
        char* filename = contents->data;
        FILE* f = fopen(filename, "rb");
        if (f == NULL) {
            fprintf(stderr, "can't open %s: %s\n",
                filename, strerror(errno));
            result = strdup("");
            goto done;
        }

        char* buffer = (char *)malloc(DTB_DATA_MAX+256);
        if (buffer == NULL) {
            fprintf(stderr, "can't malloc (%s)\n", strerror(errno));
            result = strdup("");
            goto done;
        }

        int readsize = 0;
        readsize = fread(buffer, 1, DTB_DATA_MAX+256, f);
        if (readsize > DTB_DATA_MAX) {
            fprintf(stderr, "data size(%d) out of range size(max:%d)\n",
                readsize, DTB_DATA_MAX);
            result = strdup("");
        }
        int wrote = write_chrdev_data(DTB_DEV, buffer, readsize);
        success = (wrote == readsize);
        free(buffer);
        fclose(f);
    }

    if (!success) {
        fprintf(stderr, "write_data to %s failed (%s)\n",
            DTB_DEV, strerror(errno));
    } else {
        printf("write_data to %s successful\n",
            DTB_DEV);
    }

    result = success ? strdup("dtb") : strdup("");

done:
    FreeValue(contents);
    return StringValue(result);
}

Value* SetBootloaderEnvFn(const char* name, State* state, int argc, Expr* argv[])
{
    char* result = NULL;
    int ret = 0;
    if (argc != 2) {
        return ErrorAbort(state, "%s() expects 3 args, got %d", name, argc);
    }
    char* env_name;
    char* env_val;
    if (ReadArgs(state, argv, 2, &env_name, &env_val) < 0) return NULL;

    if (strlen(env_name) == 0) {
        ErrorAbort(state, "env_name argument to %s() can't be empty", name);
        goto done;
    }

    if (strlen(env_val) == 0) {
        ErrorAbort(state, "env_val argument to %s() can't be empty", name);
        goto done;
    }

    //rm backup dtb.img and recovery.img
    if ((!strcmp(env_val, "1")) || (!strcmp(env_val, "2"))) {
        struct stat st;
        if (stat("/cache/recovery/dtb.img", &st) == 0) {
            unlink("/cache/recovery/dtb.img");
        }

         if (stat("/cache/recovery/recovery.img", &st) == 0) {
            unlink("/cache/recovery/recovery.img");
        }
    }

    ret = set_bootloader_env(env_name, env_val);
    if (!ret) {
        result = env_name;
    }
    printf("setenv %s %s %s.(%d)\n", env_name, env_val,
        (ret < 0) ? "failed" : "successful", ret);


done:
    free(env_val);
    if (result != env_name) free(env_name);
    return StringValue(result);
}

Value* OtaZipCheck(const char* name, State* state, int argc, Expr* argv[]) {

    int check = 0;
    int ret = 0;
    UpdaterInfo* ui = (UpdaterInfo*)(state->cookie);
    ZipArchive* za = ((UpdaterInfo*)(state->cookie))->package_zip;

    printf("\n-- Secure Check...\n");

    check = RecoverySecureCheck(*za);
    if (check <= 0) {
        return ErrorAbort(state, "Secure check failed. %s\n\n", !check ? "(Not match)" : "");
    } else if (check == 1) {
        printf("Secure check complete.\n\n");
    }
#ifndef RECOVERY_DISABLE_DTB_CHECK
    printf("\n-- Dtb Check...\n");

    check = RecoveryDtbCheck(*za);
    if (check != 0) {
        if (check > 1) {
            printf("dtb check not match, but can upgrade by two step.\n\n");
            return StringValue(strdup("1"));
        }
        return ErrorAbort(state, "Dtb check failed. %s\n\n", !check ? "(Not match)" : "");
    } else {
        printf("dtb check complete.\n\n");
    }
#endif
    return StringValue(strdup("0"));
}

Value* BackupDataCache(const char* name, State* state, int argc, Expr* argv[]) {
    int ret = 0;
    Value* partition;
    Value* destination;
    if (ReadValueArgs(state, argv, 2, &partition, &destination) < 0) {
        return NULL;
    }

    ret = backup_partition_data(partition->data, destination->data, 0);
    if (ret != 0) {
        printf("backup %s to %s , failed!\n", partition->data, destination->data);
    } else {
        printf("backup %s to %s , success!\n", partition->data, destination->data);
    }

    return StringValue(strdup("1"));
}

Value* RebootRecovery(const char* name, State* state, int argc, Expr* argv[]) {

    struct bootloader_message boot {};
    std::string err;

    read_bootloader_message(&boot,  &err);

    if (strstr(boot.recovery, "--update_package=")) {
        strlcat(boot.recovery, "--wipe_data\n", sizeof(boot.recovery));
    }

    printf("write_bootloader_message \n");
    if (!write_bootloader_message(boot, &err)) {
        printf("%s\n", err.c_str());
        return ErrorAbort(state, "write_bootloader_message failed!\n");
    }

    property_set(ANDROID_RB_PROPERTY, "reboot,recovery");
    sleep(5);

    return ErrorAbort(state, "reboot to recovery failed!\n");
}

void Register_libinstall_amlogic() {
    RegisterFunction("write_dtb_image", WriteDtbImageFn);
    RegisterFunction("write_bootloader_image", WriteBootloaderImageFn);
    RegisterFunction("set_bootloader_env", SetBootloaderEnvFn);
    RegisterFunction("ota_zip_check", OtaZipCheck);
    RegisterFunction("backup_data_cache", BackupDataCache);

    RegisterFunction("reboot_recovery", RebootRecovery);
}
