note
	description: "Unix implementation of `EL_EXECUTION_ENVIRONMENT_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 15:26:24 GMT (Thursday 7th July 2016)"
	revision: "8"

class
	EL_EXECUTION_ENVIRONMENT_IMP

inherit
	EL_EXECUTION_ENVIRONMENT_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

create
	make

feature {NONE} -- Implementation

	executable_file_extensions: LIST [ZSTRING]
		do
			create {ARRAYED_LIST [ZSTRING]} Result.make_from_array (<< once "" >>)
		end

	console_code_page: NATURAL
			-- For windows. Returns 0 in Unix
		do
		end

	set_console_code_page (code_page_id: NATURAL)
			-- For windows commands. Does nothing in Unix
		do
		end

feature {NONE} -- Constants

	Data_dir_name_prefix: ZSTRING
		once
			Result := "."
		end

	Search_path_separator: CHARACTER_32 = ':'

	User_configuration_directory_name: ZSTRING
		once
			Result := ".config"
		end

end
