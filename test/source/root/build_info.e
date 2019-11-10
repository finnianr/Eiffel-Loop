note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-09 15:15:25 GMT (Saturday 9th November 2019)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 01_00_07

	Build_number: NATURAL = 377

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/test"
		end

end