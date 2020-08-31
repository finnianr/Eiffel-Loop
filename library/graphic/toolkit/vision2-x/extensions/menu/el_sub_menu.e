note
	description: "Sub-menu of an application menu [$source EL_MENU]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-31 15:12:06 GMT (Monday 31st August 2020)"
	revision: "5"

deferred class
	EL_SUB_MENU

inherit
	EL_MENU
		rename
			make as make_menu,
			menu_item_list as parent_menu
		redefine
			parent_menu
		end

feature {NONE} -- Initialization

	make (a_parent_menu: like parent_menu; a_window: like window)
		do
			parent_menu := a_parent_menu
			make_menu (a_window)
		end

feature -- Basic operations

	refill
		do
			menu.wipe_out
			fill; adjust_menu_texts
		end

feature {NONE} -- Implementation

	parent_menu: EV_MENU

end
