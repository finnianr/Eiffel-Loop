note
	description: "Miscellaneous functions from [https://learn.microsoft.com/en-us/windows/win32/ Win 32 API]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-04 20:20:04 GMT (Thursday 4th January 2024)"
	revision: "1"

class
	EL_WIN_32_C_API

inherit
	EL_C_API_ROUTINES

feature {NONE} -- Path related

	frozen c_shell32_get_folder_path (folder_id: INTEGER; a_path_out: POINTER): INTEGER
			--
		external
			"C inline use <Shlobj.h>"
		alias
			"SHGetFolderPath (NULL, $folder_id, NULL, 0, $a_path_out)"
		end

	frozen max_path_count: INTEGER
		-- Maximum number of characters in path
		external
			"C [macro <limits.h>]"
		alias
			"MAX_PATH"
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

	frozen c_wait_for_single_object (process: NATURAL): INTEGER
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

	frozen c_close_handle (object_handle: NATURAL): BOOLEAN
			-- BOOL WINAPI CloseHandle(_In_ HANDLE hObject);
		external
			"C (HANDLE): EIF_BOOLEAN | <Winbase.h>"
		alias
			"CloseHandle"
		end

	frozen c_open_mutex (name: POINTER): NATURAL
		require
			not_null_pointer: is_attached (name)
		external
			"C inline use <Winbase.h>"
		alias
			"OpenMutex(MUTEX_ALL_ACCESS, FALSE, (LPCTSTR)$name)"
		end

	frozen c_create_mutex (name: POINTER): NATURAL
		require
			not_null_pointer: is_attached (name)
		external
			"C inline use <Winbase.h>"
		alias
			"CreateMutex (NULL, FALSE, (LPCTSTR)$name)"
		end

end