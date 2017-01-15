note
	description: "Summary description for {EL_WIN_FILE_INFO_C_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-15 13:42:20 GMT (Sunday 15th January 2017)"
	revision: "1"

class
	EL_WIN_FILE_INFO_C_API

feature {NONE} -- C externals

	frozen default_handle: NATURAL
		external
			"C [macro %"Windows.h%"]"
		alias
			"INVALID_HANDLE_VALUE"
		end

	frozen c_open_file (name: POINTER): NATURAL
			-- HANDLE WINAPI CreateFile(
			-- 	_In_     LPCTSTR               lpFileName,
			-- 	_In_     DWORD                 dwDesiredAccess,
			-- 	_In_     DWORD                 dwShareMode,
			-- 	_In_opt_ LPSECURITY_ATTRIBUTES lpSecurityAttributes,
			-- 	_In_     DWORD                 dwCreationDisposition,
			-- 	_In_     DWORD                 dwFlagsAndAttributes,
			-- 	_In_opt_ HANDLE                hTemplateFile
			-- );
		external
			"C inline use <Windows.h>"
		alias
			"return (EIF_NATURAL_32) CreateFile ($name, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL)"
		end

	c_get_file_time (handle: NATURAL_32; creation_time_ptr, last_access_time_ptr, last_write_time_ptr: POINTER): BOOLEAN
			-- BOOL WINAPI GetFileTime (
			--		_In_      HANDLE     hFile,
			--		_Out_opt_ LPFILETIME lpCreationTime,
			--		_Out_opt_ LPFILETIME lpLastAccessTime,
			--		_Out_opt_ LPFILETIME lpLastWriteTime
			-- );
		external
			"C signature (HANDLE, LPFILETIME, LPFILETIME, LPFILETIME): EIF_BOOLEAN use <Windows.h>"
		alias
			"GetFileTime"
		end

	frozen c_close_file (handle: NATURAL): BOOLEAN
			-- BOOL WINAPI CloseHandle(_In_ HANDLE hObject);
		external
			"C (HANDLE): EIF_BOOLEAN | <Windows.h>"
		alias
			"CloseHandle"
		end

feature {NONE} -- FILETIME C externals

	frozen c_sizeof_FILETIME: INTEGER_32
		external
			"C macro use <Windows.h>"
		alias
			"sizeof(FILETIME)"
		end

	frozen c_filetime_low_word (item_ptr: POINTER): NATURAL_64
		external
			"C [struct <Windows.h>] (FILETIME): EIF_NATURAL_64"
		alias
			"dwLowDateTime"
		end

	frozen c_filetime_high_word (item_ptr: POINTER): NATURAL_64
		external
			"C [struct <Windows.h>] (FILETIME): EIF_NATURAL_64"
		alias
			"dwHighDateTime"
		end
end
