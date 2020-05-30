note
	description: "Build specification"
	notes: "GENERATED FILE. Do not edit"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-30 11:53:19 GMT (Saturday 30th May 2020)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 02_02_09

	Build_number: NATURAL = 57

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop/manage-mp3"
		end

end