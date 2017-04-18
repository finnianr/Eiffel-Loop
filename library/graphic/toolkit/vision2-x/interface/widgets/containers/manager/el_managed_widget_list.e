note
	description: "Summary description for {EL_MANAGED_WIDGET_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-03-11 11:39:43 GMT (Saturday 11th March 2017)"
	revision: "1"

class
	EL_MANAGED_WIDGET_LIST

inherit
	ARRAYED_LIST [EL_MANAGED_WIDGET [EV_WIDGET]]
		rename
			make as make_size
		end

create
	make

convert
	make ({ARRAY [ANY]})

feature {NONE} -- Initialization

	make (list: ARRAY [ANY])
		require
			list_items_conform: list_items_conform (list)
		do
			make_size (list.count)
			across 1 |..| list.count as i loop
				if attached {like item} list [i.item] as i_th_item then
					extend (i_th_item)
				end
			end
		end

feature -- Contract Support

	list_items_conform (list: ARRAY [ANY]): BOOLEAN
		do
			Result := across 1 |..| list.count as i all list.item (i.item).generating_type <= {like item} end
		end

feature -- Basic operations

	update
		do
			do_all (agent {like item}.update)
		end

end
