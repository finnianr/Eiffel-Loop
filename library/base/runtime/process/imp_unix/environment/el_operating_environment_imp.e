note
	description: "Unix implementation of [$source EL_OPERATING_ENVIRONMENT_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 14:55:32 GMT (Sunday 5th November 2023)"
	revision: "6"

class
	EL_OPERATING_ENVIRONMENT_IMP

inherit
	EL_OPERATING_ENVIRONMENT_I

	EL_UNIX_IMPLEMENTATION

feature -- Constants

	Clear_screen_command: STRING = "clear"

	Command_option_prefix: CHARACTER = '-'
		-- Character used to prefix option in command line

	Search_path_separator: CHARACTER
			-- Character used to separate paths in a directorysearch path on this platform.
		once
			Result := ':'
		end

	Temp_directory_name: ZSTRING
			--
		once
			Result := "/tmp"
		end

	Shell_path_escape_character: CHARACTER = '\'

	Shell_character_set_to_escape: STRING = "`$%"\"
			-- Characters that should be escaped for BASH commands

	Dynamic_module_extension: STRING = "so"

	C_library_prefix: STRING = "lib"

feature -- Measurement

	is_root_path (path: STRING): BOOLEAN
			--
		do
			Result := (path @ 1 = '/')
		end

end