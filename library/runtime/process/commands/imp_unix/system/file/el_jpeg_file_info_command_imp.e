note
	description: "Unix implementation of [$source EL_JPEG_FILE_INFO_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-11 11:13:33 GMT (Thursday 11th May 2023)"
	revision: "8"

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
		rename
			eiffel_naming as camel_case_naming
		undefine
			camel_case_naming, do_command, new_command_parts, reset, set_has_error, new_representations
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

	Template: STRING = "exiv2 -p a $file_path"

end