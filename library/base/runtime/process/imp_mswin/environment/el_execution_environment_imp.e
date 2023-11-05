note
	description: "Windows implementation of [$source EL_EXECUTION_ENVIRONMENT_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:15:57 GMT (Sunday 5th November 2023)"
	revision: "16"

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
			item as item_32,
			sleep as sleep_nanosecs,
			current_working_directory as current_working_directory_obselete
		export
			{NONE} all
		undefine
			put, item_32, launch, system
		end

	EL_WINDOWS_IMPLEMENTATION

	EL_ENVIRONMENT_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Implementation

	architecture_bits: INTEGER
		once
			Result := 64
			if attached item (Processor_architecture) as str and then str.ends_with_general (once "86")
				and then not attached item (Processor_architecture_WOW6432)
			then
				Result := 32
			end
		end

	console_code_page: NATURAL
		do
			Result := c_console_output_code_page
		end

	new_language_code: STRING
			-- Two letter code representing user language
			-- Example: "en" is English
		do
			if Executable.Is_work_bench and then attached item ("LANG") as lang then
				Result := lang.substring_to ('_', default_pointer)
			else
				Result := I18n.language
			end
		end

	open_url (url: EL_FILE_URI_PATH)
		local
			l_url: NATIVE_STRING; succeeded: BOOLEAN
		do
			create l_url.make (url)
			succeeded := c_open_url (l_url.item) > 32
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

	set_library_path
		-- add build/$ISE_PLATFORM/package/bin to LD_LIBRARY_PATH for Unix platform
		do
		end

feature {NONE} -- Internal attributes

	call_suceeded: BOOLEAN

feature {NONE} -- Constants

	Data_dir_name_prefix: ZSTRING
		once
			create Result.make_empty
		end

	I18n: EL_I18N_ROUTINES
		once
			create Result
		end

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