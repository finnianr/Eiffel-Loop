note
	description: "Summary description for {EL_EXECUTION_ENVIRONMENT_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-23 13:09:58 GMT (Sunday 23rd March 2014)"
	revision: "4"

class
	EL_EXECUTION_ENVIRONMENT_IMPL

inherit
	EL_PLATFORM_IMPL

	EL_MS_WINDOWS_DIRECTORIES
		export
			{NONE} all
		end

create
	make

feature {EL_EXECUTION_ENVIRONMENT} -- Access

	console_code_page: NATURAL
		do
			Result := c_console_output_code_page
		end

feature {EL_EXECUTION_ENVIRONMENT} -- OS settings

	set_utf_8_console_output
		do
			set_console_code_page (65001)
		end

	set_console_code_page (code_page_id: NATURAL)
		do
			call_suceeded := c_set_console_output_code_page (code_page_id)
		ensure
			code_page_set: call_suceeded
		end

feature {EL_EXECUTION_ENVIRONMENT} -- Constants

	executable_file_extensions: LIST [EL_ASTRING]
		do
			Result := Executable_extensions_spec.as_lower.split (';')
			across Result as extensions loop
				extensions.item.remove_head (1)
			end
		end

	Data_dir_name_prefix: STRING = ""

	User_configuration_directory_name: STRING = "config"

feature {NONE} -- Implementation

	call_suceeded: BOOLEAN

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

end
