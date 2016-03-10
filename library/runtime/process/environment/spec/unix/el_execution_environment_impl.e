note
	description: "Summary description for {EL_EXECUTION_ENVIRONMENT_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-23 15:01:12 GMT (Sunday 23rd March 2014)"
	revision: "6"

class
	EL_EXECUTION_ENVIRONMENT_IMPL

inherit
	EL_PLATFORM_IMPL

	EXECUTION_ENVIRONMENT

create
	make

feature {EL_EXECUTION_ENVIRONMENT} -- Access

	executable_file_extensions: LIST [ASTRING]
		do
			create {ARRAYED_LIST [ASTRING]} Result.make_from_array (<< once "" >>)
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

	Data_dir_name_prefix: ASTRING
		once
			Result := "."
		end

	User_configuration_directory_name: ASTRING
		once
			Result := ".config"
		end

end
