note
	description: "Windows mutex api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_WINDOWS_MUTEX_API

inherit
	EL_POINTER_ROUTINES

feature {NONE} -- C Externals

	frozen c_open_mutex (name: POINTER): POINTER
		require
			not_null_pointer: is_attached (name)
		external
			"C inline use <Winbase.h>"
		alias
			"OpenMutex(MUTEX_ALL_ACCESS, FALSE, (LPCTSTR)$name)"
		end

	frozen c_create_mutex (name: POINTER): POINTER
		require
			not_null_pointer: is_attached (name)
		external
			"C inline use <Winbase.h>"
		alias
			"CreateMutex(NULL, FALSE, (LPCTSTR)$name)"
		end

	c_close_handle (handle: POINTER): BOOLEAN
			-- BOOL WINAPI CloseHandle( __in  HANDLE hObject);
		external
			"C (HANDLE): EIF_BOOLEAN | <Winbase.h>"
		alias
			"CloseHandle"
		end

end
