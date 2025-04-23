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

#include <windows.h>

// https://stackoverflow.com/questions/5801813/c-usleep-is-obsolete-workarounds-for-windows-mingw
void usleep(__int64 usec) { 
    HANDLE timer; 
    LARGE_INTEGER ft; 
    ft.QuadPart = -(10*usec); // Convert to 100 nanosecond interval, negative value indicates relative time
    timer = CreateWaitableTimer(NULL, TRUE, NULL); 
    SetWaitableTimer(timer, &ft, 0, NULL, NULL, 0); 
    WaitForSingleObject(timer, INFINITE); 
    CloseHandle(timer); 
}

#endif // msvc_h__
