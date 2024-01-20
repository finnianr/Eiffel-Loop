note
	description: "Unix implementation of ${EL_JPEG_FILE_INFO_COMMAND_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	EL_JPEG_FILE_INFO_COMMAND_IMP

inherit
	EL_JPEG_FILE_INFO_COMMAND_I

	EL_CAPTURED_OS_COMMAND_IMP
		rename
			make_default as make,
			eiffel_naming as camel_case_naming
		undefine
			camel_case_naming, make, new_representations, reset, set_has_error
		end

create
	make

end