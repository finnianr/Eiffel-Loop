note
	description: "[
		Command line interface to [$source JPEG_FILE_TIME_STAMPER]
		which ensures JPEG file modified time corresponds to `Exif.Image.DateTime'
	]"
	notes: "[
		Usage:
			el_toolkit -jpeg_time_stamp -source <dir-path>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-11 13:26:19 GMT (Thursday 11th May 2023)"
	revision: "19"

class
	JPEG_FILE_TIME_STAMPER_APP

inherit
	EL_COMMAND_LINE_APPLICATION [JPEG_FILE_TIME_STAMPER]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("source", "JPEG directory tree", << directory_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (".")
		end

feature {NONE} -- Constants

	Option_name: STRING = "jpeg_time_stamp"

end