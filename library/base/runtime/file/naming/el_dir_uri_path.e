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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-13 17:11:20 GMT (Saturday 13th January 2024)"
	revision: "28"

class
	EL_DIR_URI_PATH

inherit
	EL_DIR_PATH
		undefine
			append, append_file_prefix, default_create, escaped,
			make, make_from_other, normalized_copy,
			is_absolute, is_equal, is_less, is_uri, first_index, type_alias,
			Type_parent, Separator, set_path, part_count, part_string
		redefine
			Type_file_path, make_parent
		end

	EL_URI_PATH
		rename
			make_from_file_path as make_from_dir_path,
			to_file_path as to_dir_path
		undefine
			has_step
		redefine
			make_from_dir_path
		end

create
	default_create, make, make_file, make_scheme, make_from_path, make_from_dir_path, make_parent,
	make_from_encoded, make_from_uri

convert
	make ({ZSTRING, STRING_32}),
	make_from_path ({PATH}),
	make_from_dir_path ({EL_DIR_PATH}),
	make_from_encoded ({STRING, IMMUTABLE_STRING_8, EL_STRING_8}),
	make_from_uri ({EL_URI, EL_URL}),

	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}, steps: {EL_PATH_STEPS}, to_path: {PATH}

feature {NONE} -- Initialization

	make_from_dir_path (a_path: EL_DIR_PATH)
		do
			Precursor (a_path)
		end

	make_parent (other: EL_URI_PATH)
		do
			authority := other.authority.twin
			scheme := other.scheme
			Precursor (other)
		end

feature -- Conversion

	to_dir_path: EL_DIR_PATH
		do
			Result := parent_path + base
		end

feature {NONE} -- Type definitions

	Type_file_path: EL_FILE_URI_PATH
		once
		end

end