note
	description: "Win file info c api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 16:12:30 GMT (Friday 13th September 2024)"
	revision: "11"

class
	EL_WIN_FILE_INFO_C_API

feature {NONE} -- C externals

	frozen c_open_file_read (name: POINTER): POINTER
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

	frozen c_open_file_write (name: POINTER): POINTER
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
			"return (EIF_NATURAL_32) CreateFile ($name, GENERIC_WRITE, NULL, NULL, OPEN_EXISTING, 0, NULL)"
		end

	frozen c_get_file_time (handle: POINTER; creation_time_ptr, last_access_time_ptr, last_write_time_ptr: POINTER): BOOLEAN
			-- time pointers can be NULL if the application does not require this information.
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

	frozen c_set_file_time (handle: POINTER; creation_time_ptr, last_access_time_ptr, last_write_time_ptr: POINTER): BOOLEAN
			-- time pointers can be NULL if the application does not need to set this information.
			-- BOOL WINAPI SetFileTime(
			--		_In_           HANDLE   hFile,
			--		_In_opt_ const FILETIME *lpCreationTime,
			--		_In_opt_ const FILETIME *lpLastAccessTime,
			--		_In_opt_ const FILETIME *lpLastWriteTime
			-- )
			external
			"C signature (HANDLE, LPFILETIME, LPFILETIME, LPFILETIME): EIF_BOOLEAN use <Windows.h>"
		alias
			"SetFileTime"
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

	frozen c_set_filetime_low_word (item_ptr: POINTER; value: NATURAL_32)
		external
			"C [struct <Windows.h>] (FILETIME, DWORD)"
		alias
			"dwLowDateTime"
		end

	frozen c_set_filetime_high_word (item_ptr: POINTER; value: NATURAL_32)
		external
			"C [struct <Windows.h>] (FILETIME, DWORD)"
		alias
			"dwHighDateTime"
		end

end