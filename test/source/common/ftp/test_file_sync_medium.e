note
	description: "Test file sync medium"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-25 14:17:13 GMT (Thursday 25th March 2021)"
	revision: "1"

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

	make (a_path_list: LIST [EL_FILE_PATH])
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

	uploaded_path_list: LIST [EL_FILE_PATH]

end