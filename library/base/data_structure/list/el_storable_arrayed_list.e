note
	description: "Summary description for {EL_STORABLE_ARRAYED_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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