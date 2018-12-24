note
	description: "Sub-menu of an application menu [$source EL_MENU]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 11:59:34 GMT (Friday 21st December 2018)"
	revision: "4"

deferred class
	EL_SUB_MENU

inherit
	EL_MENU
		rename
			make as make_menu,
			container as parent_menu
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
