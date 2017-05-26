note
	description: "Build specification"

	notes: "GENERATED FILE. Do not edit"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-25 14:47:33 GMT (Thursday 25th May 2017)"
	revision: "2"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 01_00_00

	Build_number: NATURAL = 7

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/EROS"
		end

end
