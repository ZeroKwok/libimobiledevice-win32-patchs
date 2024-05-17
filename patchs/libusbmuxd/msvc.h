#ifndef msvc_h__
#define msvc_h__

#ifndef __attribute__
#   define __attribute__(x) /*NOTHING*/
#endif

#ifndef _WIN32
#   define _WIN32
#endif

#ifndef strcasecmp
#   include "string.h"
#   define strcasecmp _stricmp
#endif

#endif // msvc_h__
