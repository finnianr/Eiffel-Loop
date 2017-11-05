note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Python module: eiffel_loop.eiffel.ecf.py"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-18 11:20:47 GMT (Wednesday 18th October 2017)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 01_00_06

	Build_number: NATURAL = 29

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/eiffel"
		end

end