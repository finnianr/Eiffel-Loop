note
	description: "Summary description for {EL_U8_FILE_PATH_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-25 8:44:56 GMT (Tuesday 25th June 2013)"
	revision: "2"

class
	EL_FILE_PATH_LIST

inherit
	ARRAYED_LIST [EL_FILE_PATH]
		rename
			make as make_array,
			first as first_path,
			item as path,
			last as last_path
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			is_equal, copy
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make_empty
		do
			make_array (10)
		end

	make (a_dir_path: EL_DIR_PATH; wildcard: STRING)
			--
		do
			make_empty
			append_files (a_dir_path, wildcard)
		end

feature -- Element change

	append_files (a_dir_path: EL_DIR_PATH; wildcard: STRING)
		do
			append (File_system.file_list (a_dir_path, wildcard))
		end

feature -- Basic operations

	sort
		local
			l_sorted: SORTABLE_ARRAY [like path]
		do
			create l_sorted.make_from_array (to_array)
			l_sorted.sort
			make_from_array (l_sorted)
		end

end
