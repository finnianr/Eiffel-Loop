note
	description: "Summary description for {EL_RIGHT_CONTEXT_MENU_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_RIGHT_CONTEXT_MENU [G -> EL_NAMEABLE]

inherit
	EV_MENU

	EL_MODULE_LOCALE
		undefine
			 copy, default_create, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_item_list: like item_list; a_select_action: like select_action)
		do
			default_create
			item_list := a_item_list
			select_action := a_select_action
			from item_list.start until item_list.after loop
				extend (
					create {EV_MENU_ITEM}.make_with_text_and_action (
						item_list.item.name,
						agent (a_index: INTEGER)
							do
								destroy
								item_list.go_i_th (a_index)
								select_action.call ([item_list.item])

							end (item_list.index)
					)
				)
				item_list.forth
			end
		end


feature {NONE} -- Implementation

	item_list: LIST [G]

	select_action: PROCEDURE [ANY, TUPLE [G]]

end
