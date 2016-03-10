note
	description: "Summary description for {EL_DIRECTORY_NAMING_ROUTINES_U8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-08 13:53:18 GMT (Monday 8th July 2013)"
	revision: "2"

class
	EL_DIRECTORY_NAMING_ROUTINES

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_ENVIRONMENT

feature -- Factory

	path (a_path: READABLE_STRING_GENERAL): EL_DIR_PATH
		do
			create Result.make_from_unicode (a_path.as_string_32)
		end

feature -- Constants

	Home: EL_DIR_PATH
		once
			Result := Execution.home_directory
		end

	Working: EL_DIR_PATH
		once
			Result := Execution.current_working_directory
		end

	Temporary: EL_DIR_PATH
		once
			Result := Environment.Operating.Temp_directory_path
		end

	Separator: CHARACTER
		once
			Result := operating_environment.Directory_separator
		end

feature {NONE} -- Implementation

	Directory: EL_DIRECTORY
			--
		once
			create Result
		end

end
