note
	description: "Uniform Resource Identifier for a file as defined by [https://tools.ietf.org/html/rfc3986 RFC 3986]"
	notes: "[
	  The following are two example URIs and their component parts:

	         foo://example.com:8042/over/there?name=ferret#nose
	         \_/   \______________/\_________/ \_________/ \__/
	          |           |            |            |        |
	       scheme     authority       path        query   fragment
	          |   _____________________|__
	         / \ /                        \
	         urn:example:animal:ferret:nose
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-24 12:30:02 GMT (Sunday 24th May 2020)"
	revision: "15"

class
	EL_FILE_URI_PATH

inherit
	EL_FILE_PATH
		undefine
			default_create, make, make_from_other, escaped,
			is_equal, is_less, is_uri,
			Type_parent, Separator,
			set_path, part_count, part_string
		end

	EL_URI_PATH
		redefine
			make_from_file_path
		end

create
	default_create, make, make_file, make_scheme, make_from_path, make_from_file_path, make_from_encoded

convert
	make ({ZSTRING, STRING_32}),
	make_from_path ({PATH}),
	make_from_file_path ({EL_FILE_PATH}),
	make_from_encoded ({STRING}),

 	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}, steps: {EL_PATH_STEPS}, to_path: {PATH}

feature {NONE} -- Initialization

	make_from_file_path (a_path: EL_FILE_PATH)
		do
			Precursor (a_path)
		end

feature -- Conversion

	to_file_path: EL_FILE_PATH
		do
			Result := parent_path + base
		end

end
