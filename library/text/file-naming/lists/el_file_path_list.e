note
	description: "Summary description for {EL_U8_FILE_PATH_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-10 10:08:08 GMT (Saturday 10th January 2015)"
	revision: "5"

class
	EL_FILE_PATH_LIST

inherit
	ARRAYED_LIST [EL_FILE_PATH]
		rename
			make as make_with_count,
			first as first_path,
			item as path,
			last as last_path
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			is_equal, copy
		end

create
	make, make_empty, make_with_count

feature {NONE} -- Initialization

	make_empty
		do
			make_with_count (0)
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
