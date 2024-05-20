#ifndef fixmsvc_h__
#define fixmsvc_h__

#ifndef __attribute__
#   define __attribute__(x) /*NOTHING*/
#endif

#ifndef PATH_MAX
#   define PATH_MAX 256
#endif

#ifdef _MSC_VER
#define strcasecmp _stricmp
#endif

#include "unistd.h"
#include "libgen.h"

#endif // fixmsvc_h__
