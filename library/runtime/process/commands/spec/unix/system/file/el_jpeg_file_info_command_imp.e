note
	description: "Unix implementation of [$source EL_JPEG_FILE_INFO_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-01 13:01:56 GMT (Saturday 1st July 2017)"
	revision: "2"

class
	EL_JPEG_FILE_INFO_COMMAND_IMP

inherit
	EL_JPEG_FILE_INFO_COMMAND_I
		export
			{NONE} all
		undefine
			is_valid_platform
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_string, set_has_error
		redefine
			is_valid_platform
		end

create
	make, make_default

feature {NONE} -- Status query

	is_valid_platform: BOOLEAN
		do
			Result := {PLATFORM}.is_unix
		end

feature {NONE} -- Implementation

	Template: STRING = "exiv2 -g Exif.Photo.DateTimeOriginal $path"

end
