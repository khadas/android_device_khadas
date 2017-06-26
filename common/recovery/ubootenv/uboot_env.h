#ifndef BOOTLOADER_ENV_H_
#define BOOTLOADER_ENV_H_
/*
* bootloader env init
* 0: success, <0: fail
*/
extern int bootloader_env_init(void);

/*
* set bootloader environment variable
* 0: success, <0: fail
*/
extern int set_bootloader_env(const char* name, const char* value);

/*
* get bootloader environment variable
* NULL: init failed or get env value is NULL
* NONE NULL: env value
*/
extern char *get_bootloader_env(const char * name);



extern int set_env_optarg(const char * optarg);



extern int get_env_optarg(const char * optarg);

#endif