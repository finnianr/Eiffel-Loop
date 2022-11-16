note
	description: "List export volumes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	LIST_VOLUMES_TASK

inherit
	RBOX_MANAGEMENT_TASK

create
	make

feature -- Basic operations

	apply
		local
			table: EL_GVFS_MOUNT_TABLE
		do
			create table.make
			lio.put_new_line
			lio.put_line ("MOUNTED VOLUMES")
			lio.tab_right
			lio.put_new_line
			across table as mount loop
				lio.put_labeled_string (mount.key, mount.item)
				lio.put_new_line
			end
			lio.tab_left
			lio.put_new_line
		end

end