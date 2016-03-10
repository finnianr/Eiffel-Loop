note
	description: "Summary description for {EL_LOCALE_SUB_MENU}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
