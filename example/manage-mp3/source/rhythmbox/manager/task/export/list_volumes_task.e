note
	description: "List export volumes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-19 10:33:21 GMT (Tuesday 19th May 2020)"
	revision: "1"

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
