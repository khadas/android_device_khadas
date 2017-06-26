#include <errno.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include "minzip/Zip.h"

#include "dtbcheck.h"
#include "fdt/libfdt.h"



#define MAX_LEVEL	32		/* how deeply nested we will go */
#define CONFIG_CMD_FDT_MAX_DUMP 64

#define DT_HEADER_MAGIC		0xedfe0dd0	/*header of dtb file*/
#define AML_DT_HEADER_MAGIC	0x5f4c4d41	/*"AML_", multi dtbs supported*/

#define AML_DT_ID_VARI_TOTAL		3	//Total 3 strings
/*Latest version: v2*/
#define AML_DT_VERSION_OFFSET		4
#define AML_DT_TOTAL_DTB_OFFSET		8
#define AML_DT_FIRST_DTB_OFFSET		12

#define AML_DT_DTB_DT_INFO_OFFSET	0

#define ENV_DTB            "aml_dt"
#define CMDLINE            "/proc/cmdline"
#define STORE_DEVICE       "/sys/class/aml_store/store_device"
#define DEVICE_NAND        2
#define DEVICE_EMMC        1

extern int IsPlatformEncrypted(void);

extern int DtbImgEncrypted(
        const char *imageName,
        const unsigned char *imageBuffer,
        const int imageSize,
        const char *flag,
        unsigned char *encryptedbuf);

struct fdt_header *working_fdt;

static Dtb_Partition_S dtb_zip[24];
static Dtb_Partition_S dtb_dev[24];

unsigned int recovery_size1 = 32*1024*1024; //default value 32M

static int isEncrypted = 0;

struct Dtb_header {
	unsigned int  dt_magic;
	unsigned int  dt_tool_version;
	unsigned int  dt_total;
	char data[0];
};


/****************************************************************************/


unsigned int
STRTOU32(unsigned char* p){
    return (p[3]<<24)|(p[2]<<16)|(p[1]<<8)|p[0];
}

int GetDeviceType()
{
    FILE *p = NULL;
    int len = 0;
    char buffer[32] = {0};
    int type = 0;

    p = fopen(STORE_DEVICE, "r");
    if (p == NULL) {
        printf("open failed!\n");
        return -1;
    }

    len = fread(buffer, 1, 32, p);
    if (len <= 0) {
        printf("fread failed!\n");
        fclose(p);
        return -1;
    }
    fclose(p);

    printf("buffer:%s\n",buffer);

    type = atoi(buffer);
    printf("type=%d\n",type);
    return type;
}

signed int
GetDtbId(char *pdt){
    FILE *p = NULL;
    int len = 0;
    char buffer[1024] = {0};

    if (pdt == NULL) {
        printf("param error!\n");
        return -1;
    }

    p = fopen(CMDLINE, "r");
    if (p == NULL) {
        printf("open failed!\n");
        return -1;
    }

    len = fread(buffer, 1, 1023, p);
    if (len <= 0) {
        printf("fread failed!\n");
        fclose(p);
        return -1;
    }
    fclose(p);

    char *paddr=strstr(buffer, ENV_DTB);
    if (paddr == NULL) {
        printf("not find env:aml_dt !\n");
        return -1;
    }

    paddr = strtok(paddr, " ");

    paddr = paddr+strlen(ENV_DTB)+1;
    //printf("cmdline, aml_dt=%s\n", paddr);

    strcpy(pdt, paddr);
    return 0;
}


/*
 * Heuristic to guess if this is a string or concatenated strings.
 */

static int
is_printable_string(const void *data, int len){
	const char *s = (char *)data;

	/* zero length is not */
	if (len == 0)
		return 0;

	/* must terminate with zero or '\n' */
	if (s[len - 1] != '\0' && s[len - 1] != '\n')
		return 0;

	/* printable or a null byte (concatenated strings) */
	while (((*s == '\0') || isprint(*s) || isspace(*s)) && (len > 0)) {
		/*
		 * If we see a null, there are three possibilities:
		 * 1) If len == 1, it is the end of the string, printable
		 * 2) Next character also a null, not printable.
		 * 3) Next character not a null, continue to check.
		 */
		if (s[0] == '\0') {
			if (len == 1)
				return 1;
			if (s[1] == '\0')
				return 0;
		}
		s++;
		len--;
	}

	/* Not the null termination, or not done yet: not printable */
	if (*s != '\0' || (len != 0))
		return 0;

	return 1;
}



/*
 * Print the property in the best format, a heuristic guess.  Print as
 * a string, concatenated strings, a byte, word, double word, or (if all
 * else fails) it is printed as a stream of bytes.
 */
static void print_data(const void *data, int len, int *index, int flag)
{
	int j;

	/* no data, don't print */
	if (len == 0)
		return;

	/*
	 * It is a string, but it may have multiple strings (embedded '\0's).
	 */
	if (is_printable_string(data, len)) {
		j = 0;
		while (j < len) {
			if (flag == 0) {
                        strcpy(dtb_zip[*index].partition_name,  (char *)data);
			} else {
                        strcpy(dtb_dev[*index].partition_name,  (char *)data);
                    }
                     j    += strlen((char *)data) + 1;
			data += strlen((char *)data) + 1;
		}
		return;
	}

	if ((len %4) == 0) {
		if (len > CONFIG_CMD_FDT_MAX_DUMP)
			;
		else if (len == 8){
			const __be32 *p;
                    p = (__be32 *)data;
                    if (flag == 0)
                    {
                        dtb_zip[*index].partition_size = fdt32_to_cpu(p[1]) - fdt32_to_cpu(p[0]);
                    }
                    else
                    {
                        dtb_dev[*index].partition_size = fdt32_to_cpu(p[1]) - fdt32_to_cpu(p[0]);
                    }
                   (*index)++;
		}
	} else { /* anything else... hexdump */
		if (len > CONFIG_CMD_FDT_MAX_DUMP)
			;
		else {
			const unsigned char *s;
		}
	}
}


int
GetPartitionFromDtb(const char *pathp,  int depth, int *partition_num, int flag){
	static char tabs[MAX_LEVEL+1] =
		"\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t"
		"\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t";
	const void *nodep;	/* property node pointer */
	int  nodeoffset;	/* node offset from libfdt */
       int  index = 0;
	int  nextoffset;	/* next node offset from libfdt */
	uint32_t tag;		/* tag */
	int  len;		/* length of the property */
	int  level = 0;		/* keep track of nesting level */
	const struct fdt_property *fdt_prop;

	nodeoffset = fdt_path_offset (working_fdt, pathp);
	if (nodeoffset < 0) {
		/*
		 * Not found or something else bad happened.
		 */
		printf ("libfdt fdt_path_offset() returned %s\n",
			fdt_strerror(nodeoffset));
		return 1;
	}


	/*
	 * The user passed in a node path and no property,
	 * print the node and all subnodes.
	 */
	while (level >= 0) {
		tag = fdt_next_tag(working_fdt, nodeoffset, &nextoffset);
		switch (tag) {
		case FDT_BEGIN_NODE:
			pathp = fdt_get_name(working_fdt, nodeoffset, NULL);
			if (level <= depth) {
				if (pathp == NULL)
					pathp = "/* NULL pointer error */";
				if (*pathp == '\0')
					pathp = "/";	/* root is nameless */
			}
			level++;
			if (level >= MAX_LEVEL) {
				printf("Nested too deep, aborting.\n");
				return 1;
			}
			break;
		case FDT_END_NODE:
			level--;
			if (level <= depth)
				;
			if (level == 0) {
				level = -1;		/* exit the loop */
			}
			break;
		case FDT_PROP:
			fdt_prop = (struct fdt_property *)fdt_offset_ptr(working_fdt, nodeoffset,
					sizeof(*fdt_prop));
			pathp    = fdt_string(working_fdt,
					fdt32_to_cpu(fdt_prop->nameoff));
			len      = fdt32_to_cpu(fdt_prop->len);
			nodep    = fdt_prop->data;
			if (len < 0) {
				printf ("libfdt fdt_getprop(): %s\n",
					fdt_strerror(len));
				return 1;
			} else if (len == 0) {
				/* the property has no value */
				if (level <= depth)
					;
			} else {
				if (level <= depth) {
					print_data (nodep, len, &index, flag);
				}
			}
			break;
		case FDT_NOP:
			printf("%s/* NOP */\n", &tabs[MAX_LEVEL - level]);
			break;
		case FDT_END:
			return 1;
		default:
			if (level <= depth)
				printf("Unknown tag 0x%08X\n", tag);
			return 1;
		}
		nodeoffset = nextoffset;
	}

      *partition_num = index;
	return 0;
}

unsigned char *
GetMultiDtbEntry(unsigned char *fdt_addr, int *plen){
    unsigned int dt_magic = STRTOU32(fdt_addr);
    signed int dt_total = 0;
    unsigned int dt_tool_version = 0;

    //printf("      Amlogic multi-dtb tool\n");
    if (dt_magic == DT_HEADER_MAGIC) {/*normal dtb*/
        printf("      Single dtb detected\n");
        return fdt_addr;
    }
    else if (dt_magic == AML_DT_HEADER_MAGIC) {/*multi dtb*/
        printf("      Multi dtb detected\n");
        /* check and set aml_dt */
        int i = 0;
        char *aml_dt_buf;
        aml_dt_buf = (char *)malloc(sizeof(char)*64);
        memset(aml_dt_buf, 0, sizeof(aml_dt_buf));

        GetDtbId(aml_dt_buf);
        //printf("aml_dt_buf:%s\n", aml_dt_buf);

        unsigned int aml_dt_len = aml_dt_buf ? strlen(aml_dt_buf) : 0;
        if (aml_dt_len <= 0) {
            printf("Get env aml_dt failed!Ignore dtb check !\n");
            *plen = 0;
            return fdt_addr;
        }

        /*version control, compatible with v1*/
        dt_tool_version = STRTOU32(fdt_addr + AML_DT_VERSION_OFFSET);
        unsigned int aml_each_id_length=0;
        unsigned int aml_dtb_offset_offset;
        unsigned int aml_dtb_header_size;

        if (dt_tool_version == 1)
            aml_each_id_length = 4;
        else if(dt_tool_version == 2)
            aml_each_id_length = 16;

        aml_dtb_offset_offset = aml_each_id_length * AML_DT_ID_VARI_TOTAL;
        aml_dtb_header_size = 8+(aml_each_id_length * AML_DT_ID_VARI_TOTAL);
        //printf("      Multi dtb tool version: v%d .\n", dt_tool_version);

        /*fdt_addr + 0x8: num of dtbs*/
        dt_total = STRTOU32(fdt_addr + AML_DT_TOTAL_DTB_OFFSET);
        //printf("      Support %d dtbs.\n", dt_total);

        /* split aml_dt to 3 strings */
        char *tokens[3] = {NULL, NULL, NULL};
        for (i = 0; i < AML_DT_ID_VARI_TOTAL; i++) {
            tokens[i] = strsep(&aml_dt_buf, "_");
        }

        if (aml_dt_buf)
            free(aml_dt_buf);
        //printf("        aml_dt soc: %s platform: %s variant: %s\n", tokens[0], tokens[1], tokens[2]);

        /*match and print result*/
        char **dt_info;
        dt_info = (char **)malloc(sizeof(char *)*AML_DT_ID_VARI_TOTAL);
        for (i = 0; i < AML_DT_ID_VARI_TOTAL; i++)
            dt_info[i] = (char *)malloc(sizeof(char)*aml_each_id_length);

        unsigned int dtb_match_num = 0xffff;
        unsigned int x = 0, y = 0, z = 0; //loop counter
        unsigned int read_data;
        for (i = 0; i < dt_total; i++) {
            for (x = 0; x < AML_DT_ID_VARI_TOTAL; x++) {
                for (y = 0; y < aml_each_id_length; y+=4) {
                    read_data = STRTOU32(fdt_addr + AML_DT_FIRST_DTB_OFFSET + \
                        i * aml_dtb_header_size + AML_DT_DTB_DT_INFO_OFFSET + \
                        (x * aml_each_id_length) + y);
                    dt_info[x][y+0] = (read_data >> 24) & 0xff;
                    dt_info[x][y+1] = (read_data >> 16) & 0xff;
                    dt_info[x][y+2] = (read_data >> 8) & 0xff;
                    dt_info[x][y+3] = (read_data >> 0) & 0xff;
                }

                for (z=0; z<aml_each_id_length; z++) {
                    /*fix string with \0*/
                    if (0x20 == (uint)dt_info[x][z]) {
                        dt_info[x][z] = '\0';
                    }
                }
            }

            if (dt_tool_version == 1)
                printf("        dtb %d soc: %.4s   plat: %.4s   vari: %.4s\n", i, (char *)(dt_info[0]), (char *)(dt_info[1]), (char *)(dt_info[2]));
            else if(dt_tool_version == 2)
                printf("        dtb %d soc: %.16s   plat: %.16s   vari: %.16s\n", i, (char *)(dt_info[0]), (char *)(dt_info[1]), (char *)(dt_info[2]));
            uint match_str_counter = 0;

            for (z=0; z<AML_DT_ID_VARI_TOTAL; z++) {
                /*must match 3 strings*/
                if (!strncmp(tokens[z], (char *)(dt_info[z]), strlen(tokens[z])) && \
                    (strlen(tokens[z]) == strlen(dt_info[z])))
                    match_str_counter++;
            }

            if (match_str_counter == AML_DT_ID_VARI_TOTAL) {
                //printf("Find match dtb\n");
                dtb_match_num = i;
            }

            for (z=0; z<AML_DT_ID_VARI_TOTAL; z++) {
                /*clear data for next loop*/
                memset(dt_info[z], 0, sizeof(aml_each_id_length));
            }
        }

        /*clean malloc memory*/
        for (i = 0; i < AML_DT_ID_VARI_TOTAL; i++) {
            if (dt_info[i])
                free(dt_info[i]);
        }

        if (dt_info)
            free(dt_info);

        /*if find match dtb, return address, or else return main entrance address*/
        if (0xffff != dtb_match_num) {
            printf("      Find match dtb: %d\n", dtb_match_num);
            /*this offset is based on dtb image package, so should add on base address*/
            *plen = STRTOU32(fdt_addr + AML_DT_FIRST_DTB_OFFSET + \
                dtb_match_num * aml_dtb_header_size + aml_dtb_offset_offset+4);
            return fdt_addr + STRTOU32(fdt_addr + AML_DT_FIRST_DTB_OFFSET + \
			dtb_match_num * aml_dtb_header_size + aml_dtb_offset_offset);
        } else {
            printf("      Not match any dtb.\n");
            return NULL;
        }
    } else {
        printf("      Cannot find legal dtb!\n");
        return NULL;
    }

    return NULL;
}


/**
  *  --- get upgrade package image data
  *
  *  @zipArchive: zip archive object
  *  @imageName:  upgrade package image's name
  *  @imageSize:  upgrade package image's size
  *
  *  return value:
  *  <0: failed
  *  =0: can't find image
  *  >0: get image data successful
  */
static unsigned char *s_pDtbBuffer = NULL;
static int
GetZipDtbImage(const ZipArchive zipArchive, const char *imageName, int *imageSize){
    int len = 0;
    int ret = 0;
    bool success = false;
    unsigned char *paddr = NULL;

    const ZipEntry *pZipEntry = mzFindZipEntry(&zipArchive, imageName);
    if (pZipEntry == NULL) {
        return 0;
    }

    *imageSize = mzGetZipEntryUncompLen(pZipEntry);
    if (*imageSize <= 0) {
        printf("can't get package entry uncomp len(%d) (%s)\n",*imageSize, strerror(errno));
        return -1;
    }

    len = *imageSize;

    unsigned char* buffer = (unsigned char *)calloc(len, sizeof(unsigned char));
    if (!buffer) {
        printf("can't malloc %d size space (%s)\n",len, strerror(errno));
        return -1;
    }

    success = mzExtractZipEntryToBuffer(&zipArchive, pZipEntry, buffer);
    if (!success) {
        printf("can't extract package entry to image buffer\n");
        free(buffer);
        return -1;
    }

    if (isEncrypted == 1) {
        ret = DtbImgEncrypted(DTB_IMG, buffer, len, "1", buffer);
        if (ret == 2) {
            printf("no decrypt_dtb and no support!");
            free(buffer);
            return 2;
        }else if (ret <= 0) {
            printf("dtb.img encrypt from zip failed!\n");
            free(buffer);
            return -1;
        }
    }

    paddr = GetMultiDtbEntry(buffer, &len);
    if (paddr == NULL)
    {
        printf("Cannot find legal dtb from zip \n");
        free(buffer);
        return -1;
    } else if (len == 0) {
        printf("No need to check dtb \n");
        free(buffer);
        return 2;
    }

    if (s_pDtbBuffer != NULL) {
        free(s_pDtbBuffer);
        s_pDtbBuffer = NULL;
    }

    s_pDtbBuffer = (unsigned char *)calloc(len, sizeof(unsigned char));
    if (!s_pDtbBuffer) {
        printf("can't malloc %d size space (%s)\n",len, strerror(errno));
        free(buffer);
        return -1;
    }

    memcpy(s_pDtbBuffer, paddr, len);
    free(buffer);

    return 1;
}

static int
GetDevDtbImage(){
    int  fd = 0;
    int  len = 0;
    int ret = 0;
    unsigned char *paddr = NULL;
    const char *DTB_DEV=  "/dev/dtb";
    const int DTB_DATA_MAX =  256*1024;

    unsigned char* buffer = (unsigned char *)calloc(DTB_DATA_MAX+256, sizeof(unsigned char));
    if (buffer == NULL) {
        printf("malloc %d failed!\n", DTB_DATA_MAX+256);
        return -1;
    }

    fd = open(DTB_DEV, O_RDONLY);
    if (fd < 0) {
        printf("open %s failed!\n", DTB_DEV);
        free(buffer);
        return -1;
    }

    len = read(fd, buffer, DTB_DATA_MAX);
    if (len < 0) {
        printf("read failed len = %d\n", len);
        close(fd);
        free(buffer);
        return -1;
    }

    close(fd);

    if (isEncrypted == 1) {
        ret = DtbImgEncrypted(DTB_IMG, buffer, len, "1", buffer);
        if (ret <= 0) {
            printf("dtb.img encrypt from dev failed!\n");
            free(buffer);
            return -1;
        }
    }
    paddr = GetMultiDtbEntry(buffer, &len);
    if (paddr == NULL) {
        printf("Cannot find legal dtb from dev block \n");
        free(buffer);
        return -1;
    }

    if (s_pDtbBuffer != NULL) {
        free(s_pDtbBuffer);
        s_pDtbBuffer = NULL;
    }

    s_pDtbBuffer = (unsigned char *)calloc(len, sizeof(unsigned char));
    if (s_pDtbBuffer == NULL) {
        printf("malloc %d failed!\n", len);
        free(buffer);
        return -1;
    }

    memcpy(s_pDtbBuffer, paddr, len);
    free(buffer);

    return 0;
}

int
RecoveryDtbCheck(const ZipArchive zipArchive){
    int i = 0, ret = -1, err = -1;
    int fd = -1;
    int partition_num_zip = 0;
    int partition_num_dev = 0;
    int imageSize = 0;
    int recovery_dev = 0, recovery_zip = 0;
    int data_dev = 0, data_zip = 0;
    int recovery_offset_dev = 0, recovery_offset_zip = 0;
    int data_offset_dev = 0, data_offset_zip = 0;
    int device_type = 0;
    int partition_num;
    int cache_offset_dev = 0, cache_offset_zip = 0;
    int recovery_size_dev = 0, recovery_size_zip = 0;
    int cache_size_dev = 0, cache_size_zip = 0;

    isEncrypted = IsPlatformEncrypted();
    if (isEncrypted == 2) {
        printf("kernel doesn't support!\n");
        return 0;
    } else if (isEncrypted < 0) {
        return -1;
    }

    ret = GetZipDtbImage(zipArchive, DTB_IMG, &imageSize);
    if ((ret == 0) || (ret == 2)) {
        printf("no dtb.img in the update or no need check dtb, check dtb over!\n");
        return 0;
    } else if (ret < 0) {
        printf("get dtb.img from update.zip failed!\n");
        ret = -1;
        goto END;
    }

    working_fdt = (struct fdt_header *)s_pDtbBuffer;

    ret = GetPartitionFromDtb("/partitions",  MAX_LEVEL, &partition_num_zip, 0);
    if (ret  != 0) {
        printf("get partition map from dtb.img failed!\n");
        ret = -1;
        goto END;
    }

    ret = GetDevDtbImage();
    if (ret != 0) {
        printf("read dtb from /dev/dtb failed!\n");
        ret = -1;
        goto END;
    }

    working_fdt = (struct fdt_header *)s_pDtbBuffer;
    ret = GetPartitionFromDtb("/partitions", MAX_LEVEL, &partition_num_dev, 1);
    if (ret  != 0) {
        printf("get partition map from /dev/dtb failed!\n");
        ret = -1;
        goto END;
    }

    partition_num = partition_num_dev;
    device_type = GetDeviceType();
    printf("device_type = %d \n",device_type);

    if (partition_num_zip != partition_num_dev) {
        printf("partition num don't match zip:%d, dev:%d\n",partition_num_zip,  partition_num_dev);
        if (device_type == DEVICE_NAND) {
            printf("the partitions changed & device is nand! can not upgrade!\n ");
            ret = -1;
            goto END;
        }
        #ifdef SUPPORT_PARTNUM_CHANGE
        ret = 2;
        partition_num = partition_num_zip > partition_num_dev ? partition_num_zip : partition_num_dev;
        #else
        printf("partition num don't match zip:%d, dev:%d, can not upgrade!\n",partition_num_zip,  partition_num_dev);
        ret = -1;
        goto END;
        #endif
    }
    printf("partition_num = %d \n",partition_num);

    for (i=0; i<partition_num;i++) {
        printf("%s:0x%08x\n", dtb_zip[i].partition_name, dtb_zip[i].partition_size);
        printf("%s:0x%08x\n", dtb_dev[i].partition_name, dtb_dev[i].partition_size);

        if (!strcmp("recovery", dtb_dev[i].partition_name)) {
            recovery_size1 = dtb_zip[i].partition_size;
            recovery_dev = i;
            recovery_size_dev = dtb_dev[i].partition_size;
        }
        if (!strcmp("recovery", dtb_zip[i].partition_name)) {
            recovery_zip = i;
            recovery_size_zip = dtb_zip[i].partition_size;
        }

        if (!strcmp("data", dtb_dev[i].partition_name)) {
            data_dev = i;
        }
        if (!strcmp("data", dtb_zip[i].partition_name)) {
            data_zip = i;
        }

        if (!strcmp("cache", dtb_dev[i].partition_name)) {
            cache_size_dev = dtb_dev[i].partition_size;
        }
        if (!strcmp("cache", dtb_zip[i].partition_name)) {
            cache_size_zip = dtb_zip[i].partition_size;
        }

        if ((strcmp(dtb_zip[i].partition_name, dtb_dev[i].partition_name) != 0)||
                (dtb_zip[i].partition_size != dtb_dev[i].partition_size)) {
            ret = 2;
            /*just emmc support partition changes*/
            if (device_type == DEVICE_NAND) {
                printf("the partitions changed & device is nand! can not upgrade!\n ");
                ret = -1;
                goto END;
            }
        }
    }

    /*the offset of recovery/data cannot be changed*/
    for (i=0;i<recovery_dev;i++) {
        recovery_offset_dev += dtb_dev[i].partition_size;
    }
    for (i=0;i<recovery_zip;i++) {
        recovery_offset_zip += dtb_zip[i].partition_size;
    }
    for (i=0;i<data_dev;i++) {
        data_offset_dev += dtb_dev[i].partition_size;
    }
    for (i=0;i<data_zip;i++) {
        data_offset_zip += dtb_zip[i].partition_size;
    }

    for (i=0;i<2;i++) {
        cache_offset_dev += dtb_dev[i].partition_size;
        cache_offset_zip += dtb_zip[i].partition_size;
    }

    printf("recovery_dev: %d  recovery_offset_dev :0x%08x\n", recovery_dev, recovery_offset_dev);
    printf("recovery_zip: %d  recovery_offset_zip :0x%08x\n", recovery_zip, recovery_offset_zip);
    printf("data_dev: %d  data_offset_dev :0x%08x\n", data_dev, data_offset_dev);
    printf("data_zip: %d  data_offset_zip :0x%08x\n", data_zip, data_offset_zip);
    printf("cache_offset_dev :0x%08x, cache_size_dev: %d\n", cache_offset_dev, cache_size_dev);
    printf("cache_offset_zip :0x%08x, cache_size_zip: %d\n", cache_offset_zip, cache_size_zip);

    if (data_offset_dev != data_offset_zip) {
        printf("data changed, need wipe_data\n ");
        ret = 3;
    }

    if ((recovery_offset_dev != recovery_offset_zip) || (recovery_size_dev != recovery_size_zip)) {
        printf("recovery part changed! can not upgrade!\n ");
        ret = -1;
        goto END;
    }

    if ((cache_offset_dev != cache_offset_zip) || (cache_size_dev != cache_size_zip)) {
        printf("cache part changed! can not upgrade!\n ");
        ret = -1;
        goto END;
    }

END:
     if (s_pDtbBuffer != NULL)
    {
        free(s_pDtbBuffer);
        s_pDtbBuffer = NULL;
    }

    return ret;
}
