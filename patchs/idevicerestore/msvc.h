#ifndef msvc_h__
#define msvc_h__

#ifndef __attribute__
#   define __attribute__(x) /*NOTHING*/
#endif

#ifdef _MSC_VER
#define strcasecmp _stricmp
#endif

#endif // msvc_h__
