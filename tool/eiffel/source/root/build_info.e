note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-03 11:31:50 GMT (Sunday 3rd November 2019)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 01_00_34

	Build_number: NATURAL = 156

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/eiffel"
		end

end