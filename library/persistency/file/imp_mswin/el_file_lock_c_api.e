note
	description: "Windows file locking C API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-22 12:21:17 GMT (Wednesday 22nd November 2023)"
	revision: "13"

class
	EL_FILE_LOCK_C_API

inherit
	EL_C_API_ROUTINES

	EL_WINDOWS_IMPLEMENTATION

feature {NONE} -- C Externals

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

feature {NONE} -- C struct flock

	frozen c_overlap_struct_size: INTEGER
		external
			"C [macro <winbase.h>]"
		alias
			"sizeof(OVERLAPPED)"
		end

end