note
	description: "Summary description for {EL_EXECUTION_ENVIRONMENT_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-02-02 11:17:08 GMT (Sunday 2nd February 2014)"
	revision: "3"

class
	EL_EXECUTION_ENVIRONMENT_IMPL

inherit
	EL_PLATFORM_IMPL

	EL_MS_WINDOWS_DIRECTORIES
		rename
			Program_files_dir as Apps_install_dir,
			System_dir as System_command_dir
		export
			{NONE} all
			{ANY} Apps_install_dir, System_command_dir, User_profile_dir
		end

	EL_MODULE_BUILD_INFO

feature {EL_EXECUTION_ENVIRONMENT} -- Access

	user_configuration_steps: EL_PATH_STEPS
		do
			Result := user_data_directory_steps.twin
			Result.extend (user_configuration_directory_name)
		end

	user_data_directory_steps: EL_PATH_STEPS
			--
		do
			Result := Build_info.installation_sub_directory
		end

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
