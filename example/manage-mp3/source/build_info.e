note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-23 14:46:34 GMT (Thursday 23rd April 2020)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 02_02_01

	Build_number: NATURAL = 24

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/manage-mp3"
		end

end