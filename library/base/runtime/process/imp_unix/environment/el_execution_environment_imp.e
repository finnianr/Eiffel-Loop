note
	description: "Unix implementation of [$source EL_EXECUTION_ENVIRONMENT_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:03:01 GMT (Wednesday 21st February 2018)"
	revision: "4"

class
	EL_EXECUTION_ENVIRONMENT_IMP

inherit
	EL_EXECUTION_ENVIRONMENT_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

	EL_MODULE_DIRECTORY

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

	open_url (url: EL_FILE_URI_PATH)
		do
			system ({STRING_32} "xdg-open " + url.escaped.to_string_32)
		end

	set_console_code_page (code_page_id: NATURAL)
			-- For windows commands. Does nothing in Unix
		do
		end

feature {NONE} -- Constants

	Architecture_bits: INTEGER
		local
			cpu_bits_in: PLAIN_TEXT_FILE
		once
			create cpu_bits_in.make_with_name (Directory.temporary + "lscpu_head_1")
			system ("lscpu | head -n 1 > " + cpu_bits_in.path.name)
			cpu_bits_in.open_read
			cpu_bits_in.read_line
			if cpu_bits_in.last_string.ends_with ((64).out) then
				Result := 64
			else
				Result := 32
			end
			cpu_bits_in.delete
		end

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
