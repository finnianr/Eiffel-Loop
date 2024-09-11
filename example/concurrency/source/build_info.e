note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-10 9:06:22 GMT (Tuesday 10th September 2024)"
	revision: "6"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Build_number: NATURAL = 0

	Compatibility_mode: STRING = "Win7"
		-- compatibility mode for Windows for registry entry

	Installation_sub_directory: DIR_PATH
		once
			Result := "Eiffel-Loop/Concurrency Demonstration"
		end

	Version_number: NATURAL = 01_00_00

end