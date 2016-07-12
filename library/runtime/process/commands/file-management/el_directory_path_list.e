note
	description: "Summary description for {EL_DIRECTORY_PATH_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 10:02:01 GMT (Friday 1st July 2016)"
	revision: "5"

class
	EL_DIRECTORY_PATH_LIST

inherit
	ARRAYED_LIST [EL_DIR_PATH]
		rename
			make as make_array,
			first as first_path,
			item as path,
			last as last_path
		end

	EL_MODULE_OS
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

	make (a_dir_path: EL_DIR_PATH)
			--
		do
			make_empty
			append_dirs (a_dir_path)
		end

feature -- Element change

	append_dirs (a_dir_path: EL_DIR_PATH)
		do
			append (OS.directory_list (a_dir_path))
		end

end
