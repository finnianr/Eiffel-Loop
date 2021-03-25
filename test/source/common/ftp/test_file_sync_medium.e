note
	description: "Summary description for {TEST_FILE_SYNC_MEDIUM}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
