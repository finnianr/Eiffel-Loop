note
	description: "Summary description for {EL_LOCALE_SUB_MENU}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-08-29 12:06:37 GMT (Saturday 29th August 2015)"
	revision: "5"

deferred class
	EL_LOCALE_SUB_MENU

inherit
	EL_LOCALE_MENU
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