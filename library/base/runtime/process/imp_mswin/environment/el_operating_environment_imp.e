note
	description: "Windows implementation of ${EL_OPERATING_ENVIRONMENT_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-27 9:24:14 GMT (Thursday 27th March 2025)"
	revision: "10"

class
	EL_OPERATING_ENVIRONMENT_IMP

inherit
	EL_OPERATING_ENVIRONMENT_I

	EL_WINDOWS_IMPLEMENTATION

feature -- Constants

	Clear_screen_command: STRING = "cls"

	Command_option_prefix: CHARACTER = '/'
		-- Character used to prefix option in command line

	Path_quote: CHARACTER = '"'
		-- quotation mark to enclose paths that contain spaces

	Search_path_separator: CHARACTER = ';'
		-- Character used to separate paths in a directorysearch path on this platform.

	Temp_directory_name: ZSTRING
			--
		local
			environment: EXECUTION_ENVIRONMENT -- particular reason not to use `EL_EXECUTION_ENVIRONMENT_IMP' ?
		once
			create environment
			if attached environment.item ("TEMP") as temp then
				Result := temp
			else
				create Result.make_empty
			end
		end

	Dynamic_module_extension: STRING = "dll"

	C_library_prefix: STRING = ""

feature -- Measurement

	is_root_path (path: STRING): BOOLEAN
			--
		do
			Result := (path @ 1).is_alpha and path @ 2 = ':'
		end

end