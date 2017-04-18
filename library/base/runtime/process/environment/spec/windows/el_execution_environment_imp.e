note
	description: "Windows implementation of `EL_EXECUTION_ENVIRONMENT_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-17 13:30:08 GMT (Monday 17th April 2017)"
	revision: "2"

class
	EL_EXECUTION_ENVIRONMENT_IMP

inherit
	EL_EXECUTION_ENVIRONMENT_I
		export
			{NONE} all
		redefine
			set_utf_8_console_output
		end

	EL_MS_WINDOWS_DIRECTORIES
		rename
			sleep as sleep_nanosecs,
			current_working_directory as current_working_directory_obselete
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Implementation

	call_suceeded: BOOLEAN

	console_code_page: NATURAL
		do
			Result := c_console_output_code_page
		end

	set_utf_8_console_output
		do
			Precursor
			set_console_code_page (65001)
		end

	set_console_code_page (code_page_id: NATURAL)
		do
			call_suceeded := c_set_console_output_code_page (code_page_id)
		ensure then
			code_page_set: call_suceeded
		end

	open_url (url: READABLE_STRING_GENERAL)
		local
			l_url: NATIVE_STRING; succeeded: BOOLEAN
		do
			create l_url.make (String_32.general_to_unicode (url))
			succeeded := c_open_url (l_url.item) > 32
		end

feature {NONE} -- Constants

	executable_file_extensions: LIST [ZSTRING]
		do
			Result := Executable_extensions_spec.as_lower.split (';')
			across Result as extensions loop
				extensions.item.remove_head (1)
			end
		end

	Data_dir_name_prefix: ZSTRING
		once
			create Result.make_empty
		end

	Search_path_separator: CHARACTER_32 = ';'

	User_configuration_directory_name: ZSTRING
		once
			Result := "config"
		end

feature {NONE} -- C Externals

	frozen c_set_console_output_code_page (code_page_id: NATURAL): BOOLEAN
			-- BOOL WINAPI SetConsoleOutputCP(_In_  UINT wCodePageID);
		external
			"C (UINT): EIF_BOOLEAN | <Windows.h>"
		alias
			"SetConsoleOutputCP"
		end

	frozen c_console_output_code_page: NATURAL
			-- UINT WINAPI GetConsoleOutputCP(void);
		external
			"C (): EIF_NATURAL | <Windows.h>"
		alias
			"GetConsoleOutputCP"
		end

	c_open_url (url: POINTER): INTEGER
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
			"(ShellExecute (NULL, NULL, (LPCTSTR)$url, NULL, NULL, SW_SHOWNORMAL))"
		end
end
