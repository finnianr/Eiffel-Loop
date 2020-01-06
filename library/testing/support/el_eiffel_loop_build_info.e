note
	description: "Eiffel loop build info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-05 13:47:17 GMT (Sunday 5th January 2020)"
	revision: "1"

class
	EL_EIFFEL_LOOP_BUILD_INFO

inherit
	EL_BUILD_INFO

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_EIFFEL_LOOP_TEST_CONSTANTS

feature -- Constants

	Version_number: NATURAL = 01_00_00

	Build_number: NATURAL = 0

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := Eiffel_loop
			Result := Result.joined_dir_path (Execution_environment.executable_name)
		end
end
