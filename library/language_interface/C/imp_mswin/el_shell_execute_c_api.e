note
	description: "[
		Interface to the
		[https://learn.microsoft.com/en-us/windows/win32/api/shellapi/nf-shellapi-shellexecuteexw ShellExecuteExW]
		function from the Windows Shell API `<Shellapi.h>'. The 'W' suffix indicates that arguments must be
		UTF-16 encoded wide strings.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-04 20:01:11 GMT (Thursday 4th January 2024)"
	revision: "3"

class
	EL_SHELL_EXECUTE_C_API

inherit
	EL_C_API_ROUTINES

feature {NONE} -- Access

	c_process (self: POINTER): NATURAL
		--
		external
			"C [struct <Shellapi.h>] (SHELLEXECUTEINFOW): EIF_NATURAL"
		alias
			"hProcess"
		end

feature {NONE} -- Measurement

	c_size_of_SHELLEXECUTEINFOW: INTEGER
		-- The size of this structure, in bytes.
		external
			"C [macro <Shellapi.h>]"
		alias
			"sizeof (SHELLEXECUTEINFOW)"
		end

feature {NONE} -- Element change

	c_set_directory (self, a_file: POINTER)
		-- Optional address of a null-terminated string that specifies the name of the working directory.
		-- If this member is NULL, the current directory is used as the working directory.
		external
			"C [struct <Shellapi.h>] (SHELLEXECUTEINFOW, LPCWSTR)"
		alias
			"lpDirectory"
		end

	c_set_file (self, a_file: POINTER)
		-- The address of a null-terminated string that specifies the name of the file or object
		-- on which ShellExecuteEx will perform the action specified by the lpVerb parameter
		external
			"C [struct <Shellapi.h>] (SHELLEXECUTEINFOW, LPCWSTR)"
		alias
			"lpFile"
		end

	c_set_f_mask (self: POINTER; mask: NATURAL_64)
		--
		external
			"C [struct <Shellapi.h>] (SHELLEXECUTEINFOW, ULONG)"
		alias
			"fMask"
		end

	c_set_n_show (self: POINTER; type: INTEGER)
		--
		external
			"C [struct <Shellapi.h>] (SHELLEXECUTEINFOW, int)"
		alias
			"nShow"
		end

	c_set_parameters (self, a_parameters: POINTER)
		-- Optional address of a null-terminated string that contains the application parameters.
		-- The parameters must be separated by spaces. If the lpFile member specifies a document file,
		-- lpParameters should be NULL.
		external
			"C [struct <Shellapi.h>] (SHELLEXECUTEINFOW, LPCWSTR)"
		alias
			"lpParameters"
		end

	c_set_size (self: POINTER; size: INTEGER)
		-- The size of this structure, in bytes. (Required)
		external
			"C [struct <Shellapi.h>] (SHELLEXECUTEINFOW, DWORD)"
		alias
			"cbSize"
		end

	c_set_verb (self, a_verb: POINTER)
		-- A string, referred to as a verb, that specifies the action to be performed.
		-- Valid verbs: edit, explore, find, open, print, runas
		external
			"C [struct <Shellapi.h>] (SHELLEXECUTEINFOW, LPCWSTR)"
		alias
			"lpVerb"
		end

feature {NONE} -- Constants

	c_mask_no_close_process: NATURAL_64
		-- Use to indicate that the hProcess member receives the process handle.
		-- This handle is typically used to allow an application to find out when
		-- a process created with ShellExecuteEx terminates.
		external
			"C [macro <Shellapi.h>]"
		alias
			"SEE_MASK_NOCLOSEPROCESS"
		end

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

	c_shell_execute (shell_info_ptr: POINTER): BOOLEAN
		-- execute command with UTF-16 parameter information
		-- BOOL ShellExecuteExW ([in, out] SHELLEXECUTEINFOW *pExecInfo);
		external
			"C (EIF_POINTER): EIF_BOOLEAN | <Shellapi.h>"
		alias
			"ShellExecuteExW"
		end

end