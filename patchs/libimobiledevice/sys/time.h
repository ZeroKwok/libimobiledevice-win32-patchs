#include <stdint.h>
#include <Windows.h>
#include <winsock.h>

inline int gettimeofday(struct timeval *tv, struct timezone *tz)
{
	FILETIME ft;
	GetSystemTimeAsFileTime(&ft);

	// 将FILETIME结构体中的时间值转换为64位整数，单位为100纳秒
	ULARGE_INTEGER uliTime;
	uliTime.LowPart = ft.dwLowDateTime;
	uliTime.HighPart = ft.dwHighDateTime;
	uint64_t ullTime = uliTime.QuadPart;

	// 将时间值转换为自1970年1月1日00:00:00 UTC以来经过的微秒数
	static const uint64_t EPOCH_DIFFERENCE = 116444736000000000ULL;
	ullTime -= EPOCH_DIFFERENCE;
	ullTime /= 10;

	// 将时间值转换为struct timeval结构体
	tv->tv_sec = ullTime / 1000000;
	tv->tv_usec = ullTime % 1000000;

	return 0;
}