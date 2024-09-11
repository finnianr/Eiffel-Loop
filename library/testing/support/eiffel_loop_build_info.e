note
	description: "Eiffel loop build info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-09 16:23:00 GMT (Monday 9th September 2024)"
	revision: "11"

class
	EIFFEL_LOOP_BUILD_INFO

inherit
	ANY

	EL_BUILD_INFO

	EL_MODULE_EXECUTABLE

	SHARED_DEV_ENVIRON

feature -- Constants

	Build_number: NATURAL = 0

	Compatibility_mode: STRING = "Win7"
		-- Windows compatibility mode

	Installation_sub_directory: DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop
			Result := Result #+ Executable.name
		end

	Version_number: NATURAL = 01_00_00

end