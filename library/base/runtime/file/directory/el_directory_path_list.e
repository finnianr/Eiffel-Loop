note
	description: "Directory path list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-04 21:14:57 GMT (Sunday 4th December 2022)"
	revision: "11"

class
	EL_DIRECTORY_PATH_LIST

inherit
	EL_SORTABLE_ARRAYED_LIST [DIR_PATH]
		rename
			make as make_sized,
			first as first_path,
			item as path,
			last as last_path
		redefine
			make_sized
		end

create
	make, make_filled, make_sorted, make_empty, make_sized,
--	Conversion
	make_from_array, make_from, make_from_for, make_from_if

feature {NONE} -- Initialization

	make (a_dir_path: DIR_PATH)
			--
		do
			make_empty
			append_dirs (a_dir_path)
		end

	make_sized (n: INTEGER)
		do
			Precursor (n)
			create implementation
		end

feature -- Element change

	append_dirs (a_dir_path: DIR_PATH)
		do
			append (implementation.new_directory_list (a_dir_path))
		end

feature {NONE} -- Internal attributes

	implementation: EL_FILE_LISTING
end