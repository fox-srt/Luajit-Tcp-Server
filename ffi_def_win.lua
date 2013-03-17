--  ffi_def_win.lua
local ffi = require "ffi"
local bit = require "bit"

-- local bnot = bit.bnot
-- local band = bit.band
local bor = bit.bor
local lshift = bit.lshift
-- local rshift = bit.rshif

--[[
https://github.com/Wiladams/BanateCoreWin32
https://github.com/Wiladams/LJIT2Win32/blob/master/WinBase.lua
]]

-- Berkeley Sockets calls
-- https://github.com/Wiladams/LJIT2Win32/blob/master/win_socket.lua
dofile "win_socket.lua"

ffi.cdef[[
	// Windows
	// win basic structures and defines
	static const DWORD STD_INPUT_HANDLE = -10; 	//#define STD_INPUT_HANDLE    (DWORD)-10
	static const DWORD STD_OUTPUT_HANDLE = -11;	// #define STD_OUTPUT_HANDLE   (DWORD)-11
	static const DWORD STD_ERROR_HANDLE = -12;	// #define STD_ERROR_HANDLE    (DWORD)-12

	static const int ENABLE_PROCESSED_INPUT = 0x0001;	// #define ENABLE_ECHO_INPUT       0x0004
	static const int ENABLE_LINE_INPUT 			= 0x0002;	// #define ENABLE_LINE_INPUT       0x0002
	static const int ENABLE_ECHO_INPUT 			= 0x0004;	// #define ENABLE_ECHO_INPUT       0x0004

]]

-- system functions
ffi.cdef[[
	typedef struct _SYSTEM_INFO {
		union {
			DWORD  dwOemId;
			struct {
				WORD wProcessorArchitecture;
				WORD wReserved;
			};
		};
		DWORD     dwPageSize;
		LPVOID    lpMinimumApplicationAddress;
		LPVOID    lpMaximumApplicationAddress;
		DWORD_PTR dwActiveProcessorMask;
		DWORD     dwNumberOfProcessors;
		DWORD     dwProcessorType;
		DWORD     dwAllocationGranularity;
		WORD      wProcessorLevel;
		WORD      wProcessorRevision;
	} SYSTEM_INFO, *LPSYSTEM_INFO;

/*
	typedef struct _SYSTEM_INFO {
		DWORD dwPageSize;
	} SYSTEM_INFO, *LPSYSTEM_INFO;
*/
	void GetSystemInfo( LPSYSTEM_INFO lpSystemInfo );
]]

ffi.cdef[[
	// Windows
	// win basic functions

	BOOL QueryPerformanceFrequency(int64_t *lpFrequency);
	BOOL QueryPerformanceCounter(int64_t *lpPerformanceCount);

	int MultiByteToWideChar(UINT CodePage,
			DWORD    dwFlags,
			LPCSTR   lpMultiByteStr, int cbMultiByte,
			LPWSTR  lpWideCharStr, int cchWideChar);
	int WideCharToMultiByte(UINT CodePage,
			DWORD    dwFlags,
			LPCWSTR  lpWideCharStr, int cchWideChar,
			LPSTR   lpMultiByteStr, int cbMultiByte,
			LPCSTR   lpDefaultChar,
			LPBOOL  lpUsedDefaultChar);
	HANDLE GetStdHandle(
    DWORD nStdHandle // _In_
	);
	BOOL GetConsoleMode(
    HANDLE hConsoleHandle, // _In_
    LPDWORD lpMode // _Out_
	);
	BOOL SetConsoleMode(
		HANDLE hConsoleHandle, // _In_
		DWORD dwMode // _In_
	);
	BOOL ReadConsoleA(
		HANDLE hConsoleInput, // _In_
		LPVOID lpBuffer, // _Out_
		DWORD nNumberOfCharsToRead, // _In_
		LPDWORD lpNumberOfCharsRead, // _Out_
		LPVOID pInputControl // _In_opt_
	);
	void 	Sleep(int ms); // win sleep
	bool  SwitchToThread(void); // win yield
	DWORD GetLastError(void);
]]

-- shared_mem.lua
ffi.cdef[[
	HANDLE CreateFileA(
		LPCTSTR lpFileName, //
		DWORD dwDesiredAccess, //
		DWORD dwShareMode, //
		LPSECURITY_ATTRIBUTES lpSecurityAttributes, // _In_opt_
		DWORD dwCreationDisposition, //
		DWORD dwFlagsAndAttributes, //
		HANDLE hTemplateFile // _In_opt_
	);

	HANDLE CreateFileMappingA(
	  HANDLE               hFile,
  	SECURITY_ATTRIBUTES* sa,
  	DWORD                protect,
  	DWORD                size_high,
  	DWORD                size_low,
  	LPCSTR               name
	 );

	HANDLE OpenFileMapping(
		DWORD dwDesiredAccess, // _In_
		BOOL bInheritHandle, // _In_
		LPCTSTR lpName // _In_
	);

 	/* not in use

	HANDLE CreateFile(
		LPCTSTR lpFileName, //
		DWORD dwDesiredAccess, //
		DWORD dwShareMode, //
		LPSECURITY_ATTRIBUTES lpSecurityAttributes, // _In_opt_
		DWORD dwCreationDisposition, //
		DWORD dwFlagsAndAttributes, //
		HANDLE hTemplateFile // _In_opt_
	);
	HANDLE CreateFileMapping(
		HANDLE hFile, // _In_
		LPSECURITY_ATTRIBUTES lpAttributes, // _In_opt_
		DWORD flProtect, // _In_
		DWORD dwMaximumSizeHigh, // _In_
		DWORD dwMaximumSizeLow, // _In_
		LPCTSTR lpName // _In_opt_
	);
	HANDLE CreateFileW ( // http://source.winehq.org/WineAPI/CreateFileW.html
		LPCWSTR               filename,
		DWORD                 access,
		DWORD                 sharing,
		LPSECURITY_ATTRIBUTES sa,
		DWORD                 creation,
		DWORD                 attributes,
		HANDLE                template
	 );

	*/

	LPVOID MapViewOfFile(
    HANDLE hFileMappingObject, // _In_
    DWORD dwDesiredAccess, // _In_
    DWORD dwFileOffsetHigh, // _In_
    DWORD dwFileOffsetLow, // _In_
    SIZE_T dwNumberOfBytesToMap // _In_
	);
	BOOL UnmapViewOfFile(
    LPCVOID lpBaseAddress // _In_
	);
	BOOL CloseHandle(
  	HANDLE hObject // _In_
	);
	DWORD GetFileSize(
  	HANDLE hFile, // _In_
  	LPDWORD lpFileSizeHigh // _Out_opt_
	);
]]

--  thread.lua
ffi.cdef[[
		static const int INFINITE = 0xFFFFFFFF;
]]
--[[ffi.cdef[ [
	// Windows
	// https://github.com/Wiladams/BanateCoreWin32/blob/master/win_kernel32.lua
	HMODULE GetModuleHandleA(LPCSTR lpModuleName);
	BOOL CloseHandle(HANDLE hObject);
	HANDLE CreateEventA(LPSECURITY_ATTRIBUTES lpEventAttributes,
			BOOL bManualReset, BOOL bInitialState, LPCSTR lpName);
	HANDLE CreateIoCompletionPort(HANDLE FileHandle,
		HANDLE ExistingCompletionPort,
		ULONG_PTR CompletionKey,
		DWORD NumberOfConcurrentThreads);
	HANDLE CreateThread(
		LPSECURITY_ATTRIBUTES lpThreadAttributes,
		size_t dwStackSize,
		LPTHREAD_START_ROUTINE lpStartAddress,
		LPVOID lpParameter,
		DWORD dwCreationFlags,
		LPDWORD lpThreadId);
	DWORD ResumeThread(HANDLE hThread);
	BOOL SwitchToThread(void);
	DWORD SuspendThread(HANDLE hThread);
	void * GetProcAddress(HMODULE hModule, LPCSTR lpProcName);
	// DWORD QueueUserAPC(PAPCFUNC pfnAPC, HANDLE hThread, ULONG_PTR dwData);
]]


-- socket.lua
-- copied from: https://github.com/hnakamur/luajit-examples/blob/master/socket/cdef/socket.lua
ffi.cdef[[
	// these are defined in win_socket.lua, but inside structures
	static const int IPPROTO_IP				= 0;		// dummy for IP
	static const int IPPROTO_TCP			= 6;		// tcp
	static const int IPPROTO_UDP			= 17;		// user datagram protocol

	static const int SOCK_STREAM     = 1;    // stream socket
	static const int SOCK_DGRAM      = 2;    // datagram socket

	static const int AF_UNSPEC 		= 0;          // unspecified
	static const int AF_UNIX 			= 1;          // local to host (pipes, portals)
	static const int AF_INET 			= 2;          // internetwork: UDP, TCP, etc.

	static const unsigned long INADDR_ANY             = 0x00000000;
	static const unsigned long INADDR_BROADCAST       = 0xffffffff;
	static const int INADDR_LOOPBACK        = 0x7f000001;
	static const int INADDR_NONE            = 0xffffffff;

	// end win_socket.lua redefines
]]

ffi.cdef[[
	// Constants for getaddrinfo()
	static const int AI_PASSIVE                  =0x00000001;
		// get address to use bind(), Socket address will be used in bind() call
	static const int AI_CANONNAME                =0x00000002;
		//fill ai_canonname, Return canonical name in first ai_canonname
	static const int AI_NUMERICHOST              =0x00000004;
		// prevent host name resolution, Nodename must be a numeric address string
	static const int AI_NUMERICSERV              =0x00000008;
		// prevent service name resolution, Servicename must be a numeric port number

	static const int AI_ALL		= 0x00000100; /* IPv6 and IPv4-mapped (with AI_V4MAPPED) */
	// static const int AI_V4MAPPED_CFG	= 0x00000200; /* accept IPv4-mapped if kernel supports */
	static const int AI_ADDRCONFIG	= 0x00000400; /* only if any address is assigned */
	static const int AI_V4MAPPED	= 0x00000800; /* accept IPv4-mapped IPv6 address */
		// special recommended flags for getipnodebyname
	// static const int AI_DEFAULT	= (AI_V4MAPPED_CFG | AI_ADDRCONFIG);
	// static const int AI_MASK = (AI_PASSIVE | AI_CANONNAME | AI_NUMERICHOST | AI_NUMERICSERV | AI_ADDRCONFIG);

	// Constants for getnameinfo()
	static const int NI_MAXHOST = 1025;
	static const int NI_MAXSERV = 32;

	// Flag values for getnameinfo()
	static const int NI_NOFQDN			= 0x00000001;
	static const int NI_NUMERICHOST	= 0x00000002;
	static const int NI_NAMEREQD		= 0x00000004;
	static const int NI_NUMERICSERV	= 0x00000008;
	static const int NI_DGRAM				= 0x00000010;
	static const int NI_WITHSCOPEID	= 0x00000020;

	/* options for socket level */
	static const int SOL_SOCKET 	= 0xffff;

	/* Option flags per-socket. */
	static const int SO_DEBUG        = 0x0001;          /* turn on debugging info recording */
	static const int SO_ACCEPTCONN   = 0x0002;          /* socket has had listen() */
	static const int SO_REUSEADDR    = 0x0004;          /* allow local address reuse */
	static const int SO_KEEPALIVE    = 0x0008;          /* keep connections alive */
	static const int SO_DONTROUTE    = 0x0010;          /* just use interface addresses */
	static const int SO_BROADCAST    = 0x0020;          /* permit sending of broadcast msgs */
	static const int SO_USELOOPBACK  = 0x0040;          /* bypass hardware when possible */
	static const int SO_LINGER       = 0x0080;          /* linger on close if data present */
	static const int SO_OOBINLINE    = 0x0100;          /* leave received OOB data in line */
	static const int SO_DONTLINGER   			= (int)(~SO_LINGER);
	static const int SO_EXCLUSIVEADDRUSE 	= ((int)(~SO_REUSEADDR)); /* disallow local address reuse */

	static const int 		FORMAT_MESSAGE_FROM_SYSTEM = 0x00001000;
	static const int 		FORMAT_MESSAGE_IGNORE_INSERTS = 0x00000200;

	static const int SD_RECEIVE = 0; // Shutdown receive operations.
	static const int SD_SEND 		= 1; // Shutdown send operations.
	static const int SD_BOTH 		= 2; // Shutdown both send and receive operations.

	typedef uint32_t socklen_t;
	typedef uint16_t in_port_t;
	typedef unsigned short int sa_family_t;
	typedef uint32_t in_addr_t;

	// Basic system type definitions, taken from the BSD file sys/types.h.
	typedef unsigned char   u_char;
	typedef unsigned short  u_short;
	typedef unsigned int    u_int;
	typedef unsigned long   u_long;

	// methods
	int getnameinfo(
		const struct sockaddr  *sa, // _In_ FAR
		socklen_t salen, // _In_
		char  *host, // _Out_ FAR
		DWORD hostlen, // _In_
		char  *serv, // _Out_ FAR
		DWORD servlen, // _In_
		int flags // _In_
	);
	DWORD FormatMessageA(
		DWORD dwFlags, // _In_
    LPCVOID lpSource, // _In_opt_
    DWORD dwMessageId, // _In_
		DWORD dwLanguageId, // _In_
		LPTSTR lpBuffer, // _Out_
 		DWORD nSize, // _In_
    va_list *Arguments // _In_opt_
	);
	int WSACleanup(void);
]]
