note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-02 12:28:26 GMT (Thursday 2nd April 2020)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 01_01_12

	Build_number: NATURAL = 7

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/test"
		end

end