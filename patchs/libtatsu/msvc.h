#ifndef msvc_h__
#define msvc_h__

#ifdef WIN32
#include <windows.h>
#include <unistd.h>
#define __mkdir(path, mode) mkdir(path)
#ifndef sleep
#define sleep(x) Sleep(x*1000)
#endif
#define __usleep(x) Sleep(x/1000)
#else
#include <sys/stat.h>
#define __mkdir(path, mode) mkdir(path, mode)
#define __usleep(x) usleep(x)
#endif

#endif // msvc_h__