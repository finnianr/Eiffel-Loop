note
	description: "Summary description for {EL_STORABLE_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-02-03 14:21:14 GMT (Wednesday 3rd February 2016)"
	revision: "3"

class
	EL_STORABLE_ARRAYED_LIST [G -> EL_STORABLE]

inherit
	EL_ARRAYED_LIST [G]

feature {NONE} -- Event handler

	on_delete
		require
			item_deleted: item.is_deleted
		do
		end

end
