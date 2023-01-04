note
	description: "Unescaped URI to a file"
	notes: "[
	  Example URIs and their component parts:

			  foo://example.com:8042/over/there
			  \_/   \______________/\_________/
			   |           |            |
			scheme     authority       path
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-29 17:27:52 GMT (Thursday 29th December 2022)"
	revision: "25"

class
	EL_FILE_URI_PATH

inherit
	EL_FILE_PATH
		undefine
			append, append_file_prefix, default_create, escaped, make, make_from_other, normalized_copy,
			is_absolute, is_equal, is_less, is_uri, first_index, type_alias,
			Type_parent, Separator, set_path, part_count, part_string
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