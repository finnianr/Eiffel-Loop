note
	description: "[
		Command line interface to ${JPEG_FILE_TIME_STAMPER}
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
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "20"

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