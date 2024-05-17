#ifndef _MSC_VER 
#   define __libgen_h__
#endif
#ifndef __libgen_h__
#define __libgen_h__

#include "dirent.h"

static void usleep(__int64 usec) {
    HANDLE timer;
    LARGE_INTEGER ft;
    ft.QuadPart = -(10 * usec);
    timer = CreateWaitableTimer(NULL, TRUE, NULL);
    SetWaitableTimer(timer, &ft, 0, NULL, NULL, 0);
    WaitForSingleObject(timer, INFINITE);
    CloseHandle(timer);
}

#ifndef ISSLASH
#   define ISSLASH(C) ((C) == '/' || (C) == '\\')
#endif

#ifndef FILESYSTEM_PREFIX_LEN
#   define FILESYSTEM_PREFIX_LEN(Filename) 0
#endif

static char* basename(char const* name) {
    char const* base = name + FILESYSTEM_PREFIX_LEN(name);
    char const* p;

    for (p = base; *p; p++) {
        if (ISSLASH(*p)) {
            do p++;
            while (ISSLASH(*p));

            if (!*p) {
                if (ISSLASH(*base))
                    base = p - 1;
                break;
            }
            base = p;
        }
    }

    return (char*)base;
}

static size_t dirlen(char const* path) {
    size_t prefix_length = FILESYSTEM_PREFIX_LEN(path);
    size_t length;
    for (length = basename(path) - path; prefix_length < length; length--)
        if (!ISSLASH(path[length - 1]))
            return length;
    return prefix_length + ISSLASH(path[prefix_length]);
}

static char* dirname(char const* path) {
    size_t length = dirlen(path);
    int append_dot = (length == FILESYSTEM_PREFIX_LEN(path));
    char* newpath = (char*)malloc(length + append_dot + 1);
    memcpy(newpath, path, length);
    if (append_dot)
        newpath[length++] = '.';
    newpath[length] = 0;
    return newpath;
}

#endif // __libgen_h__
