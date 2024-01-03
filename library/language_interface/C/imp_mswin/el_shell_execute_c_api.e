note
	description: "[
		Interface to the
		[https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shellexecutea ShellExecute]
		function from the Windows Shell API `<Shellapi.h>'
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-03 15:57:19 GMT (Wednesday 3rd January 2024)"
	revision: "2"

class
	EL_SHELL_EXECUTE_C_API

inherit
	EL_C_API_ROUTINES

feature {NONE} -- Constants

	c_hide: INTEGER
		-- Hides the window and activates another window.
		external
			"C [macro <Shellapi.h>]"
		alias
			"SW_HIDE"
		end

	c_show_normal: INTEGER
		-- If the window is minimized or maximized, `SW_SHOWNORMAL' restores it to its original size and position.
		external
			"C [macro <Shellapi.h>]"
		alias
			"SW_SHOWNORMAL"
		end

feature {NONE} -- Basic operations

	c_shell_execute (hwnd, operation, file, parameters, directory: POINTER; n_show_cmd: INTEGER): INTEGER
		-- If the function succeeds, it returns a value greater than 32. If the function fails,
		--  it returns an error value that indicates the cause of the failure. The return value
		-- is cast as an HINSTANCE for backward compatibility with 16-bit Windows applications.
		-- It is not a true HINSTANCE, however. It can be cast only to an INT_PTR and compared
		--  to either 32 or the following error codes below.

		--	HINSTANCE ShellExecute (
		--		_In_opt_ HWND    hwnd,
		--		_In_opt_ LPCTSTR lpOperation,
		--		_In_     LPCTSTR lpFile,
		--		_In_opt_ LPCTSTR lpParameters,
		--		_In_opt_ LPCTSTR lpDirectory,
		--		_In_     INT     nShowCmd
		--	);

		external
			"C (EIF_POINTER, EIF_POINTER, EIF_POINTER, EIF_POINTER, EIF_POINTER, EIF_INTEGER): EIF_INTEGER%
				% | <Shellapi.h>"
		alias
			"ShellExecute"
		end

end