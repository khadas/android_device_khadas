#ifndef _RECOVERY_INSTALL_AMLOGIC_H_
#define _RECOVERY_INSTALL_AMLOGIC_H_

#include "common.h"
#include "device.h"

void amlogic_init();

void amlogic_get_args(int *argc, char ***argv);

void setup_cache_mounts();

int ensure_path_mounted_extra(Volume *v);

#endif

