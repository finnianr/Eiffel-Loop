note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-08 11:40:31 GMT (Monday 8th March 2021)"
	revision: "2"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 01_00_00

	Build_number: NATURAL = 0

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/Concurrency Demonstration"
		end

end