note
	description: "Windows implementation of [$source EL_JPEG_FILE_INFO_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-21 7:49:06 GMT (Sunday 21st May 2023)"
	revision: "3"

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