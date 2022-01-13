note
	description: "[
		Command line interface to [$source UNDATED_PHOTO_FINDER] which compiles a
		list of JPEG photos that lack the EXIF field `Exif.Photo.DateTimeOriginal'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 11:37:36 GMT (Thursday 13th January 2022)"
	revision: "15"

class
	UNDATED_PHOTO_FINDER_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [UNDATED_PHOTO_FINDER]
		redefine
			Option_name, visible_types
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("source", "Source tree directory", << directory_must_exist >>),
				required_argument ("output", "Output directory path")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (".", "undated-photos.txt")
		end

	visible_types: TUPLE [UNDATED_PHOTO_FINDER]
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "undated_photos"

end