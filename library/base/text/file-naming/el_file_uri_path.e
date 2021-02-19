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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-18 17:31:41 GMT (Thursday 18th February 2021)"
	revision: "19"

class
	EL_FILE_URI_PATH

inherit
	EL_FILE_PATH
		undefine
			append_file_prefix, default_create, make, make_from_other, escaped,
			is_absolute, is_equal, is_less, is_uri,
			Type_parent, Separator, Separator_z_code,
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