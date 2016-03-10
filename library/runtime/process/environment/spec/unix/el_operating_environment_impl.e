note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-02-02 11:03:48 GMT (Sunday 2nd February 2014)"
	revision: "3"

class
	EL_OPERATING_ENVIRONMENT_IMPL

inherit
	EL_PLATFORM_IMPL

feature -- Access

	Command_option_prefix: CHARACTER = '-'
		-- Character used to prefix option in command line

	CPU_model_name: STRING
			--
		local
			cpu_info: EL_CPU_INFO_COMMAND
		once
			create cpu_info.make
			Result := cpu_info.model_name
		end

	Search_path_separator: CHARACTER
			-- Character used to separate paths in a directorysearch path on this platform.
		once
			Result := ':'
		end

	Temp_directory_name: STRING_32
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
