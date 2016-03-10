note
	description: "Summary description for {EL_OPERATING_ENVIRONMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-19 11:20:34 GMT (Friday 19th December 2014)"
	revision: "5"

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

feature {NONE} -- Implementation

	implementation: EL_OPERATING_ENVIRONMENT_IMPL
			--
		once
			create Result
		end

end
