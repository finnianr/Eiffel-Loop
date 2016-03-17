note
	description: "Summary description for {EL_EXECUTION_ENVIRONMENT_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:06:54 GMT (Wednesday 16th December 2015)"
	revision: "8"

class
	EL_EXECUTION_ENVIRONMENT_IMPL

inherit
	EL_PLATFORM_IMPL

	EXECUTION_ENVIRONMENT

create
	make

feature {EL_EXECUTION_ENVIRONMENT} -- Access

	executable_file_extensions: LIST [ZSTRING]
		do
			create {ARRAYED_LIST [ZSTRING]} Result.make_from_array (<< once "" >>)
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

	Data_dir_name_prefix: ZSTRING
		once
			Result := "."
		end

	User_configuration_directory_name: ZSTRING
		once
			Result := ".config"
		end

end
