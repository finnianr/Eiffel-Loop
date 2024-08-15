note
	description: "Miscellaneous functions from [https://learn.microsoft.com/en-us/windows/win32/ Win 32 API]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-15 14:25:26 GMT (Thursday 15th August 2024)"
	revision: "5"

class
	EL_WIN_32_C_API

inherit
	EL_C_API

feature {NONE} -- Standard library

	frozen c_byte_swap_unsigned_short (v: NATURAL_16): NATURAL_16
		-- unsigned short _byteswap_ushort ( unsigned short val );
		external
			"C (unsigned short): EIF_NATURAL_16 | <stdlib.h>"
		alias
			"_byteswap_ushort"
		end

	frozen c_byte_swap_unsigned_long (v: NATURAL_32): NATURAL_32
		-- unsigned long _byteswap_ulong ( unsigned long val );
		external
			"C (unsigned long): EIF_NATURAL_32 | <stdlib.h>"
		alias
			"_byteswap_ulong"
		end

	frozen c_byte_swap_unsigned_int64 (v: NATURAL_64): NATURAL_64
		-- unsigned __int64 _byteswap_uint64 ( unsigned __int64 val );
		external
			"C (unsigned __int64): EIF_NATURAL_64 | <stdlib.h>"
		alias
			"_byteswap_uint64"
		end

feature {NONE} -- File API

	frozen c_create_file_mutex (path: POINTER): POINTER
			-- Create or open a file mutex
		external
			"C inline use <Windows.h>"
		alias
			"[
				CreateFileW (
					(LPCTSTR)$path, GENERIC_READ | GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
				)
			]"
		end

	frozen c_create_file_write (path: POINTER): POINTER
			-- Create or open a file for writing
		external
			"C inline use <Windows.h>"
		alias
			"[
				CreateFileW (
					(LPCTSTR)$path, GENERIC_WRITE, FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
				)
			]"
		end

	frozen c_file_truncate (file_handle: POINTER)
		external
			"C inline use <windows.h>"
		alias
			"[
				{
					HANDLE hFile = (HANDLE)$file_handle;
					SetFilePointer (hFile, 0, NULL, FILE_BEGIN);
        			SetEndOfFile (hFile);
				}
			]"
		end

	frozen c_lock_file (file_handle, overlapped: POINTER; n_bytes_low, n_bytes_high: NATURAL): BOOLEAN
		-- BOOL LockFileEx(
		--		[in]		HANDLE       hFile,
		--		[in]		DWORD        dwFlags,
		--	 				DWORD        dwReserved,
		--		[in]		DWORD        nNumberOfBytesToLockLow,
		--		[in]		DWORD        nNumberOfBytesToLockHigh,
		--		[in, out] LPOVERLAPPED lpOverlapped
		-- );
		require
			file_handle_attached: is_attached (file_handle)
			overlapped_attached: is_attached (overlapped)
		external
			"C inline use <windows.h>"
		alias
			"[
				LockFileEx (
					(HANDLE)$file_handle, LOCKFILE_EXCLUSIVE_LOCK | LOCKFILE_FAIL_IMMEDIATELY, 0,
					(DWORD)$n_bytes_low, (DWORD)$n_bytes_high, (LPOVERLAPPED)$overlapped
				)
			]"
		end

	frozen c_unlock_file (file_handle, overlapped: POINTER; n_bytes_low, n_bytes_high: NATURAL): BOOLEAN
		-- BOOL UnlockFileEx (
		-- 	[in]			HANDLE			 hFile,
		-- 					DWORD				dwReserved,
		-- 	[in]			DWORD				nNumberOfBytesToUnlockLow,
		-- 	[in]			DWORD				nNumberOfBytesToUnlockHigh,
		-- 	[in, out]	LPOVERLAPPED lpOverlapped
		-- );
		require
			file_handle_attached: is_attached (file_handle)
			overlapped_attached: is_attached (overlapped)
		external
			"C inline use <windows.h>"
		alias
			"[
				UnlockFileEx (
					(HANDLE)$file_handle, 0,
					(DWORD)$n_bytes_low, (DWORD)$n_bytes_high, (LPOVERLAPPED)$overlapped
				)
			]"
		end

	frozen c_write_file (a_handle, a_buffer: POINTER; count: INTEGER; written_count, overlapped: POINTER): BOOLEAN
			-- SDK WriteFile
		external
			"C blocking macro signature (HANDLE, LPCVOID, DWORD, LPDWORD, LPOVERLAPPED): BOOL use <windows.h>"
		alias
			"WriteFile"
		end

feature {NONE} -- Path related

	frozen c_shell32_get_folder_path (folder_id: INTEGER; a_path_out: POINTER): INTEGER
			--
		external
			"C inline use <Shlobj.h>"
		alias
			"SHGetFolderPath (NULL, $folder_id, NULL, 0, $a_path_out)"
		end

feature {NONE} -- Console output

	frozen c_console_output_code_page: NATURAL
			-- UINT WINAPI GetConsoleOutputCP(void);
		external
			"C (): EIF_NATURAL | <Windows.h>"
		alias
			"GetConsoleOutputCP"
		end

	frozen c_set_console_output_code_page (code_page_id: NATURAL): BOOLEAN
			-- BOOL WINAPI SetConsoleOutputCP(_In_  UINT wCodePageID);
		external
			"C (UINT): EIF_BOOLEAN | <Windows.h>"
		alias
			"SetConsoleOutputCP"
		end

feature {NONE} -- Shell API

	frozen c_open_url (url: POINTER): INTEGER
			--	HINSTANCE ShellExecute(
			--		_In_opt_ HWND    hwnd,
			--		_In_opt_ LPCTSTR lpOperation,
			--		_In_     LPCTSTR lpFile,
			--		_In_opt_ LPCTSTR lpParameters,
			--		_In_opt_ LPCTSTR lpDirectory,
			--		_In_     INT     nShowCmd
			--	);

			-- If the function succeeds, it returns a value greater than 32. If the function fails,
			-- it returns an error value that indicates the cause of the failure.
		external
			"C inline use <Shellapi.h>"
		alias
			"[
				ShellExecute (NULL, L"open", (LPCTSTR)$url, NULL, NULL, SW_SHOWNORMAL)
			]"
		end

	frozen c_wait_for_single_object (process: POINTER): INTEGER
		-- Waits until the specified process object is in the signaled state or the time-out interval elapses.
		-- DWORD WaitForSingleObject(
		-- 	[in] HANDLE hHandle,
		-- 	[in] DWORD  dwMilliseconds
		-- );
		external
			"C inline use <Windows.h>"
		alias
			"[
				WaitForSingleObject ((HANDLE)$process, INFINITE)
			]"
		end

feature {NONE} -- Win32 base

	frozen c_close_handle (object_handle: POINTER): BOOLEAN
			-- BOOL WINAPI CloseHandle(_In_ HANDLE hObject);
		external
			"C (HANDLE): EIF_BOOLEAN | <Winbase.h>"
		alias
			"CloseHandle"
		end

	frozen c_get_last_error: NATURAL
		-- DWORD GetLastError();
		external
			"C (): EIF_NATURAL | <Winbase.h>"
		alias
			"GetLastError"
		end

	frozen c_open_mutex (name: POINTER): NATURAL
		require
			not_null_pointer: is_attached (name)
		external
			"C inline use <Winbase.h>"
		alias
			"OpenMutex (MUTEX_ALL_ACCESS, FALSE, (LPCTSTR)$name)"
		end

	frozen c_create_mutex (name: POINTER): NATURAL
		require
			not_null_pointer: is_attached (name)
		external
			"C inline use <Winbase.h>"
		alias
			"CreateMutex (NULL, FALSE, (LPCTSTR)$name)"
		end

feature {NONE} -- Internationalization

	frozen c_get_user_default_locale_id: INTEGER
		-- the locale identifier for the user default locale, represented as LOCALE_USER_DEFAULT.
		-- If the user default locale is a custom locale, this function always returns LOCALE_CUSTOM_DEFAULT,
		-- regardless of the custom locale that is selected. For example, whether the user locale is Hawaiian
		-- (US), haw-US, or Fijiian (Fiji), fj-FJ, the function returns the same value.
		external
			"C (): LCID| <windows.h>"
		alias
			"GetUserDefaultLCID"
		end

feature {NONE} -- Error constants

	frozen c_error_already_exists: NATURAL
			-- Cannot create a file when that file already exists.
		external
			"C [macro <WinError.h>]"
		alias
			"ERROR_ALREADY_EXISTS"
		end

	frozen c_invalid_handle_value: POINTER
		external
			"C [macro <Winbase.h>]"
		alias
			"INVALID_HANDLE_VALUE"
		end

feature {NONE} -- Size constants

	frozen c_overlap_struct_size: INTEGER
		external
			"C [macro <winbase.h>]"
		alias
			"sizeof(OVERLAPPED)"
		end

	frozen max_path_count: INTEGER
		-- Maximum number of characters in path
		external
			"C [macro <limits.h>]"
		alias
			"MAX_PATH"
		end

feature {NONE} -- Folder constants

	frozen c_folder_id_common_desktop: INTEGER
			-- The file system directory that contains files and folders that appear on the desktop for all users.
			-- A typical path is C:\Documents and Settings\All Users\Desktop.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_COMMON_DESKTOPDIRECTORY"
		end

	frozen c_folder_id_common_programs: INTEGER
			-- The file system directory that contains the directories for the common program groups
			-- that appear on the Start menu for all users.
			-- typical path is C:\Documents and Settings\All Users\Start Menu\Programs
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_COMMON_PROGRAMS"
		end

	frozen c_folder_id_desktop: INTEGER
			-- The file system directory used to physically store file objects on the desktop
			-- (not to be confused with the desktop folder itself).
			-- A typical path is C:\Documents and Settings\username\Desktop.		
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_DESKTOPDIRECTORY"
		end

	frozen c_folder_id_my_documents: INTEGER
			-- typical path is "C:\Users\xxx\My Documents".
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_MYDOCUMENTS"
		end

	frozen c_folder_id_program_files: INTEGER
			-- typical path is C:\Program Files.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_PROGRAM_FILES"
		end

	frozen c_folder_id_user_profile: INTEGER
			-- typical path is C:\Users\<username>.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_PROFILE"
		end

	frozen c_folder_id_system: INTEGER
			-- The Windows System folder.
			-- A typical path is C:\Windows\System32.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_SYSTEM"
		end

end