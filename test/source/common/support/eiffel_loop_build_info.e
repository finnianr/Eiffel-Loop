note
	description: "Eiffel loop build info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:50 GMT (Monday 3rd January 2022)"
	revision: "5"

class
	EIFFEL_LOOP_BUILD_INFO

inherit
	EL_BUILD_INFO

	EL_MODULE_EXECUTABLE

	EIFFEL_LOOP_TEST_CONSTANTS

feature -- Constants

	Version_number: NATURAL = 01_00_00

	Build_number: NATURAL = 0

	Installation_sub_directory: DIR_PATH
		once
			Result := Eiffel_loop
			Result := Result.joined_dir_path (Executable.name)
		end
end
