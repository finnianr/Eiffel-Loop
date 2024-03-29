note
	description: "Eiffel loop build info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-30 13:59:03 GMT (Monday 30th October 2023)"
	revision: "10"

class
	EIFFEL_LOOP_BUILD_INFO

inherit
	ANY

	EL_BUILD_INFO

	EL_MODULE_EXECUTABLE

	SHARED_DEV_ENVIRON

feature -- Constants

	Version_number: NATURAL = 01_00_00

	Build_number: NATURAL = 0

	Installation_sub_directory: DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop
			Result := Result #+ Executable.name
		end
end