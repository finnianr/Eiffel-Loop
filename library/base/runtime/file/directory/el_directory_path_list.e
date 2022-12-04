note
	description: "Directory path list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-04 12:42:13 GMT (Sunday 4th December 2022)"
	revision: "9"

class
	EL_DIRECTORY_PATH_LIST [IMP -> EL_FILE_OPERATION create default_create end]

inherit
	ARRAYED_LIST [DIR_PATH]
		rename
			make as make_array,
			first as first_path,
			item as path,
			last as last_path
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make_empty
		do
			make_array (10)
		end

	make (a_dir_path: DIR_PATH)
			--
		do
			make_empty
			append_dirs (a_dir_path)
		end

feature -- Element change

	append_dirs (a_dir_path: DIR_PATH)
		local
			implementation: IMP
		do
			create implementation
			append (implementation.new_directory_list (a_dir_path))
		end

end