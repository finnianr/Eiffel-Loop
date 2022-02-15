note
	description: "Unescaped URI to a directory"
	notes: "[
	  The following are two example URIs and their component parts:

			  foo://example.com:8042/over/there
			  \_/   \______________/\_________/
			   |           |            |
			scheme     authority       path
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 15:36:28 GMT (Tuesday 15th February 2022)"
	revision: "3"

class
	EL_DIR_URI_PATH

inherit
	EL_URI_PATH [EL_DIR_PATH]
		rename
			make_from_file_path as make_from_dir_path,
			to_file_path as to_dir_path
		redefine
			make_from_dir_path
		end

	EL_DIR_PATH
		undefine
			append_path, make, is_absolute, is_uri, last_is_empty, Separator
		redefine
			Type_file_path
		end

create
	default_create, make, make_file, make_from_encoded, make_scheme, make_from_dir_path,
	make_from_path

convert
	make ({ZSTRING, STRING_32}),
	make_from_path ({PATH}),
	make_from_dir_path ({EL_DIR_PATH}),
	make_from_encoded ({STRING}),

 	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}, to_path: {PATH}

feature {NONE} -- Initialization

	make_from_dir_path (a_path: EL_DIR_PATH)
		do
			Precursor (a_path)
		end

feature {NONE} -- Type definitions

	Type_file_path: EL_FILE_URI_PATH
		once
			create Result
		end

end