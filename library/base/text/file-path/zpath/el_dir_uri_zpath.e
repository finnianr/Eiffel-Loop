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
	date: "2022-02-14 18:49:23 GMT (Monday 14th February 2022)"
	revision: "1"

class
	EL_DIR_URI_ZPATH

inherit
	EL_URI_ZPATH

	EL_DIR_ZPATH
		undefine
			make, is_absolute, is_uri, Separator
		end

create
	make, make_file, make_from_encoded, make_scheme

convert
	make ({ZSTRING, STRING_32})

end