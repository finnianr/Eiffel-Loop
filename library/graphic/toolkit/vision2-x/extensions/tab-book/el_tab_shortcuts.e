note
	description: "Base class for notebooks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-15 9:23:59 GMT (Thursday 15th February 2024)"
	revision: "10"

deferred class
	EL_TAB_SHORTCUTS

inherit
	EV_ANY_HANDLER

	EL_KEY_MODIFIER_CONSTANTS
		export
			{NONE} all
		end

	EL_SHARED_KEY_CONSTANTS; EL_MODULE_ACTION

feature {NONE} -- Initialization

	init_keyboard_shortcuts (a_window: EV_WINDOW)
		local
			shortcuts: EL_KEYBOARD_SHORTCUTS
		do
			create shortcuts.make (a_window)
			shortcuts.extend (Ctrl, Key.Key_page_up, agent select_left_tab)
			shortcuts.extend (Ctrl, Key.Key_page_down, agent select_right_tab)
		end

feature -- Basic operations

	select_left_tab
			-- select tab to left wrapping around to last if gone past the first tab
		deferred
		end

	select_right_tab
			-- select tab to right of current wrapping around to first if gone past the last tab
		deferred
		end

end