/* Set console input/output CP to UTF-8 via Win32 API (not chcp.com). */
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

int main(void)
{
	SetConsoleCP(65001);
	SetConsoleOutputCP(65001);
	return 0;
}
