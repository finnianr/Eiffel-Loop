note
	description: "Dir uri path"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-23 12:45:44 GMT (Sunday 23rd December 2018)"
	revision: "9"

class
	EL_DIR_URI_PATH

inherit
	EL_DIR_PATH
		undefine
			default_create, count, make, make_from_other,
			is_equal, is_less, is_path_absolute, is_uri,
			to_string, Type_parent, hash_code, Separator,
			set_path
		redefine
			Type_file_path
		end

	EL_URI_PATH
		rename
			make_from_file_path as make_from_dir_path
		undefine
			has_step
		redefine
			make_from_dir_path
		end

create
	default_create, make, make_file, make_protocol,
	make_from_general, make_from_path, make_from_dir_path

convert
	make ({ZSTRING}),
	make_from_general ({STRING_32, STRING}),
	make_from_path ({PATH}),
	make_from_dir_path ({EL_DIR_PATH}),

 	to_string: {ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}, steps: {EL_PATH_STEPS}, to_path: {PATH}

feature {NONE} -- Initialization

	make_from_dir_path (a_path: EL_DIR_PATH)
		do
			Precursor (a_path)
		end

feature {NONE} -- Type definitions

	Type_file_path: EL_FILE_URI_PATH
		once
		end

end
