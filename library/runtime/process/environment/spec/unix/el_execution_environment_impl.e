note
	description: "Summary description for {EL_EXECUTION_ENVIRONMENT_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-02-02 11:10:20 GMT (Sunday 2nd February 2014)"
	revision: "5"

class
	EL_EXECUTION_ENVIRONMENT_IMPL

inherit
	EL_PLATFORM_IMPL

	EXECUTION_ENVIRONMENT

	EL_MODULE_BUILD_INFO

	EL_MODULE_STRING

feature {EL_EXECUTION_ENVIRONMENT} -- Access

	user_configuration_steps: EL_PATH_STEPS
		do
			Result := Build_info.installation_sub_directory
			Result.put_front (user_configuration_directory_name)
		end

	user_data_directory_steps: EL_PATH_STEPS
			--
		do
			Result := Build_info.installation_sub_directory
			Result.first.prepend (Data_dir_name_prefix)
		end

	user_profile_dir: EL_DIR_PATH
		do
			create Result.make_from_path (Home_directory_path)
		end

	executable_file_extensions: LIST [EL_ASTRING]
		do
			create {ARRAYED_LIST [EL_ASTRING]} Result.make_from_array (<< once "" >>)
		end

	console_code_page: NATURAL
			-- For windows. Returns 0 in Unix
		do
		end

feature {EL_EXECUTION_ENVIRONMENT} -- OS settings

	set_utf_8_console_output
			-- For windows commands. Does nothing in Unix
		do
		end

	set_console_code_page (code_page_id: NATURAL)
			-- For windows commands. Does nothing in Unix
		do
		end

feature {EL_EXECUTION_ENVIRONMENT} -- Constants


	Data_dir_name_prefix: EL_ASTRING
		once
			Result := {STRING_32} "."
		end

	Apps_install_dir: EL_FILE_PATH
		once
			Result := {STRING_32} "/opt"
		end

--	Apps_install_path: STRING is "/home/finnian/opt"

	System_command_dir: EL_FILE_PATH
		once
			Result := {STRING_32} "/usr/bin"
		end

	User_configuration_directory_name: EL_ASTRING
		once
			Result := {STRING_32} ".config"
		end

end
