note
	description: "Directory path list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:51:29 GMT (Monday 1st July 2019)"
	revision: "6"

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
