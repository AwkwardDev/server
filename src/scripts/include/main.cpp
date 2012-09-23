#if defined(WIN32) && !defined(__MINGW32__)
#  include <windows.h>
    BOOL APIENTRY DllMain(HANDLE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
    {
        return true;
    }
#endif
