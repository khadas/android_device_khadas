#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#include "ubootenv.h"
#include "SysWrite.h"
#include "DisplayMode.h"

int set_display_mode(const char *path)
{
    bootenv_init();

    SysWrite *pSysWrite = new SysWrite();
    DisplayMode *pDisplayMode=  new DisplayMode(path);
    pSysWrite->setProperty(PROP_FS_MODE, "recovery");
    pDisplayMode->init();
    return 0;
}