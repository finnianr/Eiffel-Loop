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
	date: "2020-07-22 10:21:34 GMT (Wednesday 22nd July 2020)"
	revision: "18"

class
	EL_DIR_URI_PATH

inherit
	EL_DIR_PATH
		undefine
			append_file_prefix, default_create, make, make_from_other, escaped,
			is_absolute, is_equal, is_less, is_uri,
			Type_parent, Separator,
			set_path, part_count, part_string
		redefine
			Type_file_path
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
	default_create, make, make_file, make_scheme, make_from_path, make_from_dir_path, make_from_encoded

convert
	make ({ZSTRING, STRING_32}),
	make_from_path ({PATH}),
	make_from_dir_path ({EL_DIR_PATH}),
	make_from_encoded ({STRING}),

 	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}, steps: {EL_PATH_STEPS}, to_path: {PATH}

feature {NONE} -- Initialization

	make_from_dir_path (a_path: EL_DIR_PATH)
		do
			Precursor (a_path)
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
