note
	description: "List export volumes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-09 11:02:57 GMT (Tuesday 9th May 2023)"
	revision: "3"

class
	LIST_VOLUMES_TASK

inherit
	RBOX_MANAGEMENT_TASK

	EL_GVFS_ROUTINES
		rename
			display_volumes as apply
		end

create
	make

end