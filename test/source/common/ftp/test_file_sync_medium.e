note
	description: "Test file sync medium"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	TEST_FILE_SYNC_MEDIUM

inherit
	EL_LOCAL_FILE_SYNC_MEDIUM
		rename
			make as make_default
		redefine
			copy_item
		end

create
	make

feature {NONE} -- Initialization

	make (a_path_list: LIST [FILE_PATH])
		do
			make_default
			uploaded_path_list := a_path_list
		end

feature -- Basic operations

	copy_item (item: EL_FILE_SYNC_ITEM)
		do
			Precursor (item)
			uploaded_path_list.extend (item.file_path)
		end

feature {NONE} -- Internal attributes

	uploaded_path_list: LIST [FILE_PATH]

end