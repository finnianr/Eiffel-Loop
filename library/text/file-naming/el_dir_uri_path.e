note
	description: "Summary description for {EL_DIR_URI_PATH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_DIR_URI_PATH

inherit
	EL_DIR_PATH
		undefine
			default_create, make_from_other, is_equal, is_less, make, is_uri, is_path_absolute,
			to_string, Type_parent, hash_code, Separator
		redefine
			Type_file_path
		end

	EL_URI_PATH

create
	default_create, make, make_from_unicode, make_from_latin1, make_from_path, make_from_dir_path

convert
	make ({ASTRING}),
	make_from_latin1 ({STRING}),
	make_from_unicode ({STRING_32}),
	make_from_path ({PATH}),
	make_from_dir_path ({EL_DIR_PATH}),

 	to_string: {ASTRING}, unicode: {READABLE_STRING_GENERAL}, steps: {EL_PATH_STEPS}, to_path: {PATH}

feature {NONE} -- Initialization

	make_from_dir_path (a_path: EL_DIR_PATH)
		require
			absolute: a_path.is_absolute
		do
			if {PLATFORM}.is_windows then
				make (Forward_slash + a_path.as_unix.to_string)
			else
				make (a_path.to_string)
			end
		end

feature {NONE} -- Type definitions

	Type_file_path: EL_FILE_URI_PATH
		once
		end

end
