note
	description: "Summary description for {EL_OPERATING_ENVIRONMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_OPERATING_ENVIRONMENT

inherit
	OPERATING_ENVIRONMENT

	EL_CROSS_PLATFORM_ABS

feature -- Access

	Command_option_prefix: CHARACTER
			-- Character used to prefix option in command line
		once
			Result := implementation.Command_option_prefix
		end

	Search_path_separator: CHARACTER
			-- Character used to separate paths in a directorysearch path on this platform.
		once
			Result := implementation.Search_path_separator
		end

	Temp_directory_path: EL_DIR_PATH
			--
		once
			create Result.make_from_unicode (implementation.Temp_directory_name)
		end

	CPU_model_name: STRING
			--
		once
			Result := Implementation.cpu_model_name
			Result.replace_substring_all ("(R)", "")
		end

	Shell_path_escape_character: CHARACTER
		once
			Result := Implementation.Shell_path_escape_character
		end

	Shell_character_set_to_escape: READABLE_STRING_GENERAL
		once
			Result := Implementation.Shell_character_set_to_escape
		end

	Dynamic_module_extension: STRING
		once
			Result := Implementation.Dynamic_module_extension
		end

	C_library_prefix: STRING
		once
			Result := Implementation.C_library_prefix
		end

feature -- Measurement

	is_root_path (path: STRING): BOOLEAN
			--
		do
			Result := Implementation.is_root_path (path)
		end

feature -- Conversion

	shell_escaped (a_string: EL_ASTRING): EL_ASTRING
			-- string with characters escaped that are not accepted by shell
		do
			Result := a_string.escaped (Shell_character_set_to_escape, Shell_path_escape_character)
		end

feature {NONE} -- Implementation

	implementation: EL_OPERATING_ENVIRONMENT_IMPL
			--
		once
			create Result
		end

end
