#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#include "ubootenv/Ubootenv.h"
#include "SysWrite.h"
#include "DisplayMode.h"

int set_display_mode(const char *path)
{
    Ubootenv *pUbootenv = new Ubootenv();
    SysWrite *pSysWrite = new SysWrite();

    DisplayMode displayMode(path, pUbootenv);
    //setBootEnv
    //displayMode.setBootEnv("upgrade_step", "1");
    pUbootenv->updateValue("upgrade_step", "1");
    pSysWrite->setProperty(PROP_FS_MODE, "recovery");
    displayMode.init();

    return 0;
}