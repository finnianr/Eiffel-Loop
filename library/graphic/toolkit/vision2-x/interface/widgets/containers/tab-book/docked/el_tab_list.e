note
	description: "Summary description for {EL_TAB_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_TAB_LIST [G -> EL_DOCKED_TAB]

inherit
	ARRAYED_LIST [G]

create
	make_from_same_types

feature {NONE} -- Initialization

	make_from_same_types (a_list: LIST [EL_DOCKED_TAB])
		do
			make (a_list.count // 2)
			across a_list as tab loop
				if attached {G} tab.item as same_type_tab then
					extend (same_type_tab)
				end
			end
		end

end
