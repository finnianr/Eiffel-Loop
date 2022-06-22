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
	date: "2022-02-15 17:54:55 GMT (Tuesday 15th February 2022)"
	revision: "2"

class
	EL_FILE_URI_PATH

inherit
	EL_URI_PATH [EL_FILE_PATH]

	EL_FILE_PATH
		undefine
			append_path, make, is_absolute, is_uri, last_is_empty, Separator
		end

create
	default_create, make, make_file, make_from_file_path, make_from_path, make_from_encoded, make_scheme

convert
	make ({ZSTRING, STRING_32}),
	make_from_path ({PATH}),
	make_from_file_path ({FILE_PATH}),
	make_from_encoded ({STRING}),

 	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL},
 	to_path: {PATH}

end