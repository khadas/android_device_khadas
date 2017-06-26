#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <ctype.h>
#include <fcntl.h>
#include <fs_mgr.h>
#include "roots.h"
#include "install.h"
#include "ui.h"
#include <dirent.h>
#include "bootloader_message/bootloader_message.h"
#include "recovery_amlogic.h"

#include "ubootenv/set_display_mode.h"

extern "C" {
#include "ubootenv/uboot_env.h"
}

static const int MAX_ARGS = 100;
static const int MAX_ARG_LENGTH = 4096;
#define NUM_OF_BLKDEVICE_TO_ENUM    3
#define NUM_OF_PARTITION_TO_ENUM    6

static const char *UDISK_COMMAND_FILE = "/udisk/factory_update_param.aml";
static const char *SDCARD_COMMAND_FILE = "/sdcard/factory_update_param.aml";

extern "C"
{
    extern int remoteinit(const char* path);
}

void setup_cache_mounts() {
    int ret = 0;
    ret = ensure_path_mounted("/cache");
    if (ret != 0) {
        format_volume("/cache");
    }
}



static int mount_fs_rdonly(char *device_name, Volume *vol, const char *fs_type) {
    if (!mount(device_name, vol->mount_point, fs_type,
        MS_NOATIME | MS_NODEV | MS_NODIRATIME | MS_RDONLY, 0)) {
        LOGW("successful to mount %s on %s by read-only\n",
            device_name, vol->mount_point);
        return 0;
    } else {
        LOGE("failed to mount %s on %s by read-only (%s)\n",
            device_name, vol->mount_point, strerror(errno));
    }

    return -1;
}

int auto_mount_fs(char *device_name, Volume *vol) {
    if (access(device_name, F_OK)) {
        return -1;
    }

    if (!strcmp(vol->fs_type, "auto")) {
        if (!mount(device_name, vol->mount_point, "vfat",
            MS_NOATIME | MS_NODEV | MS_NODIRATIME, "")) {
            goto auto_mounted;
        } else {
            if (strstr(vol->mount_point, "sdcard")) {
                LOGW("failed to mount %s on %s (%s).try read-only ...\n",
                    device_name, vol->mount_point, strerror(errno));
                if (!mount_fs_rdonly(device_name, vol, "vfat")) {
                    goto auto_mounted;
                }
            }
        }

        if (!mount(device_name, vol->mount_point, "ntfs",
            MS_NOATIME | MS_NODEV | MS_NODIRATIME, "")) {
            goto auto_mounted;
        } else {
            if (strstr(vol->mount_point, "sdcard")) {
                LOGW("failed to mount %s on %s (%s).try read-only ...\n",
                    device_name, vol->mount_point, strerror(errno));
                if (!mount_fs_rdonly(device_name, vol, "ntfs")) {
                    goto auto_mounted;
                }
            }
        }

        if (!mount(device_name, vol->mount_point, "exfat",
            MS_NOATIME | MS_NODEV | MS_NODIRATIME, "")) {
            goto auto_mounted;
        } else {
            if (strstr(vol->mount_point, "sdcard")) {
                LOGW("failed to mount %s on %s (%s).try read-only ...\n",
                    device_name, vol->mount_point, strerror(errno));
                if (!mount_fs_rdonly(device_name, vol, "exfat")) {
                    goto auto_mounted;
                }
            }
        }
    } else {
        if(!mount(device_name, vol->mount_point, vol->fs_type,
            MS_NOATIME | MS_NODEV | MS_NODIRATIME, "")) {
            goto auto_mounted;
        } else {
            if (strstr(vol->mount_point, "sdcard")) {
                LOGW("failed to mount %s on %s (%s).try read-only ...\n",
                    device_name, vol->mount_point, strerror(errno));
                if (!mount_fs_rdonly(device_name, vol, vol->fs_type)) {
                    goto auto_mounted;
                }
            }
        }
    }

    return -1;

auto_mounted:
    return 0;
}

int customize_smart_device_mounted(
    Volume *vol) {
    int i = 0, j = 0;
    int first_position = 0;
    int second_position = 0;
    char * tmp = NULL;
    char *mounted_device = NULL;
    char device_name[256] = {0};
    char device_boot[256] = {0};
    const char *usb_device = "/dev/block/sd";
    const char *sdcard_device = "/dev/block/mmcblk";

    if (vol->blk_device != NULL) {
        int num = 0;
        const char *blk_device = vol->blk_device;
        for (; *blk_device != '\0'; blk_device ++) {
            if (*blk_device == '#') {
                num ++;
            }
        }

        /*
        * Contain two '#' for blk_device name in recovery.fstab
        * such as /dev/block/sd## (udisk)
        * such as /dev/block/mmcblk#p# (sdcard)
        */
        if (num != 2) {
            return 1;   // Don't contain two '#'
        }

        if (access(vol->mount_point, F_OK)) {
            mkdir(vol->mount_point, 0755);
        }

        // find '#' position
        if (strchr(vol->blk_device, '#')) {
            tmp = strchr(vol->blk_device, '#');
            first_position = tmp - vol->blk_device;
            if (strlen(tmp+1) > 0 && strchr(tmp+1, '#')) {
                tmp = strchr(tmp+1, '#');
                second_position = tmp - vol->blk_device;
            }
        }

        if (!first_position || !second_position) {
            LOGW("decompose blk_device error(%s) in recovery.fstab\n",
                vol->blk_device);
            return -1;
        }

        int copy_len = (strlen(vol->blk_device) < sizeof(device_name)) ?
            strlen(vol->blk_device) : sizeof(device_name);

        for (i = 0; i < NUM_OF_BLKDEVICE_TO_ENUM; i ++) {
            memset(device_name, '\0', sizeof(device_name));
            strncpy(device_name, vol->blk_device, copy_len);

            if (!strncmp(device_name, sdcard_device, strlen(sdcard_device))) {
                // start from '0' for mmcblk0p#
                device_name[first_position] = '0' + i;
            } else if (!strncmp(device_name, usb_device, strlen(usb_device))) {
                // start from 'a' for sda#
                device_name[first_position] = 'a' + i;
            }

            for (j = 1; j <= NUM_OF_PARTITION_TO_ENUM; j ++) {
                device_name[second_position] = '0' + j;
                if (!access(device_name, F_OK)) {
                    LOGW("try mount %s ...\n", device_name);
                    if (!auto_mount_fs(device_name, vol)) {
                        mounted_device = device_name;
                        LOGW("successful to mount %s\n", device_name);
                        goto mounted;
                    }
                }
            }

            if (!strncmp(device_name, sdcard_device, strlen(sdcard_device))) {
                // mmcblk0p1->mmcblk0
                device_name[strlen(device_name) - 2] = '\0';
                sprintf(device_boot, "%s%s", device_name, "boot0");
                // TODO: Here,need to distinguish between cards and flash at best
            } else if (!strncmp(device_name, usb_device, strlen(usb_device))) {
                // sda1->sda
                device_name[strlen(device_name) - 1] = '\0';
            }

            if (!access(device_name, F_OK)) {
                if (strlen(device_boot) && (!access(device_boot, F_OK))) {
                    continue;
                }

                LOGW("try mount %s ...\n", device_name);
                if (!auto_mount_fs(device_name, vol)) {
                    mounted_device = device_name;
                    LOGW("successful to mount %s\n", device_name);
                    goto mounted;
                }
            }
        }
    } else {
        LOGE("Can't get blk_device\n");
    }

    return -1;

mounted:
    return 0;
}

int smart_device_mounted(Volume *vol) {
    int i = 0, len = 0;
    char * tmp = NULL;
    char device_name[256] = {0};
    char *mounted_device = NULL;

    mkdir(vol->mount_point, 0755);

    if (vol->blk_device != NULL) {
        int ret = customize_smart_device_mounted(vol);
        if (ret <= 0) {
            return ret;
        }
    }

    if (vol->blk_device != NULL) {
        tmp = strchr(vol->blk_device, '#');
        len = tmp - vol->blk_device;
        if (tmp && len < 255) {
            strncpy(device_name, vol->blk_device, len);
            for (i = 1; i <= NUM_OF_PARTITION_TO_ENUM; i++) {
                device_name[len] = '0' + i;
                device_name[len + 1] = '\0';
                LOGW("try mount %s ...\n", device_name);
                if (!access(device_name, F_OK)) {
                    if (!auto_mount_fs(device_name, vol)) {
                        mounted_device = device_name;
                        LOGW("successful to mount %s\n", device_name);
                        goto mounted;
                    }
                }
            }

            const char *mmcblk = "/dev/block/mmcblk";
            if (!strncmp(device_name, mmcblk, strlen(mmcblk))) {
                device_name[len - 1] = '\0';
            } else {
                device_name[len] = '\0';
            }

            LOGW("try mount %s ...\n", device_name);
            if (!access(device_name, F_OK)) {
                if (!auto_mount_fs(device_name, vol)) {
                    mounted_device = device_name;
                    LOGW("successful to mount %s\n", device_name);
                    goto mounted;
                }
            }
        } else {
            LOGW("try mount %s ...\n", vol->blk_device);
            strncpy(device_name, vol->blk_device, sizeof(device_name));
            if (!access(device_name, F_OK)) {
                if (!auto_mount_fs(device_name, vol)) {
                    mounted_device = device_name;
                    LOGW("successful to mount %s\n", device_name);
                    goto mounted;
                }
            }
        }
    }

    return -1;

mounted:
    return 0;
}


//return value
// 0     mount OK
// -1   mount Faile
// 2    ignorel
int ensure_path_mounted_extra(Volume *v) {
    Volume* vUsb = volume_for_path("/udisk");
    char tmp[128] = {0};

    if (strcmp(v->fs_type, "ext4") == 0) {
        if (strstr(v->mount_point, "system")) {
            if (!mount(v->blk_device, v->mount_point, v->fs_type,
                 MS_NOATIME | MS_NODEV | MS_NODIRATIME | MS_RDONLY, "")) {
                 return 0;
            }
        } else {
            if (!mount(v->blk_device, v->mount_point, v->fs_type,
                 MS_NOATIME | MS_NODEV | MS_NODIRATIME, "discard")) {
                 return 0;
            }
        }
        LOGE("failed to mount %s (%s)\n", v->mount_point, strerror(errno));
        return -1;
    } else if (strcmp(v->fs_type, "vfat") == 0 ||
               strcmp(v->fs_type, "auto") == 0 ) {
        if (strstr(v->mount_point, "sdcard") || strstr(v->mount_point, "udisk")) {
            int time_out = 2000000;
            while (time_out) {
                if (!smart_device_mounted(v)) {
                    return 0;
                }
                usleep(100000);
                time_out -= 100000;
            }
        } else {
            if (!mount(v->blk_device, v->mount_point, v->fs_type,
                MS_NOATIME | MS_NODEV | MS_NODIRATIME | MS_RDONLY, "")) {
                return 0;
            }
        }
        LOGE("failed to mount %s (%s)\n", v->mount_point, strerror(errno));
        return -1;
    } else {
        return 2;//not deal
    }
}

void amlogic_init() {
    set_display_mode("/etc/mesondisplay.cfg");
    remoteinit("/etc/remote.conf");
}

void amlogic_get_args(int *argc, char ***argv) {

    // --- if that doesn't work, try the command file form environment:recovery_command
    if (*argc <= 1) {
        char *parg = NULL;
        char *recovery_command = get_bootloader_env("recovery_command");
        if (recovery_command != NULL && strcmp(recovery_command, "")) {
            char *argv0 = (*argv)[0];
            *argv = (char **) malloc(sizeof(char *) * MAX_ARGS);
            (*argv)[0] = argv0;  // use the same program name

            char buf[MAX_ARG_LENGTH];
            strcpy(buf, recovery_command);

            if ((parg = strtok(buf, "#")) == NULL) {
                LOGE("Bad bootloader arguments\n\"%.20s\"\n", recovery_command);
            } else {
                (*argv)[1] = strdup(parg);  // Strip newline.
                for (*argc = 2; *argc < MAX_ARGS; ++*argc) {
                    if ((parg = strtok(NULL, "#")) == NULL) {
                        break;
                    } else {
                        (*argv)[*argc] = strdup(parg);  // Strip newline.
                    }
                }
                LOGI("Got arguments from bootloader\n");
            }
        } else {
            LOGE("Bad bootloader arguments\n\"%.20s\"\n", recovery_command);
        }
    }

    // --- sleep 3 second to ensure USB & SD card initialization complete
    usleep(1000000);

    char *temp_args = NULL;
    // --- if that doesn't work, try the udisk command file
    if (*argc <= 1) {
        FILE *fp = fopen_path(UDISK_COMMAND_FILE, "r");
        if (fp != NULL) {
            char *argv0 = (*argv)[0];
            *argv = (char **) malloc(sizeof(char *) * MAX_ARGS);
            (*argv)[0] = argv0;  // use the same program name

            char buf[MAX_ARG_LENGTH];
            for (*argc = 1; *argc < MAX_ARGS; ) {
                if (!fgets(buf, sizeof(buf), fp)) break;
                temp_args = strtok(buf, "\r\n");
                if (temp_args == NULL)  continue;
                (*argv)[*argc]  = strdup(temp_args);   // Strip newline.
                ++*argc;
            }

            fflush(fp);
            fclose(fp);
            LOGI("Got arguments from %s\n", UDISK_COMMAND_FILE);
        }
    }

    // --- if that doesn't work, try the sdcard command file
    if (*argc <= 1) {
        FILE *fp = fopen_path(SDCARD_COMMAND_FILE, "r");
        if (fp != NULL) {
            char *argv0 = (*argv)[0];
            *argv = (char **) malloc(sizeof(char *) * MAX_ARGS);
            (*argv)[0] = argv0;  // use the same program name

            char buf[MAX_ARG_LENGTH];
            for (*argc = 1; *argc < MAX_ARGS; ) {
                if (!fgets(buf, sizeof(buf), fp)) break;
                temp_args = strtok(buf, "\r\n");
                if (temp_args == NULL)  continue;
                (*argv)[*argc]  = strdup(temp_args);  // Strip newline.
                ++*argc;
            }

            fflush(fp);
            fclose(fp);
            LOGI("Got arguments from %s\n", SDCARD_COMMAND_FILE);
        }
    }

    // --- if no argument, then force show_text
    if (*argc <= 1) {
        char *argv0 = (*argv)[0];
        *argv = (char **) malloc(sizeof(char *) * MAX_ARGS);
        (*argv)[0] = argv0;  // use the same program name
        (*argv)[1] = (char *)"--show_text";
        *argc = 2;
    }
}
