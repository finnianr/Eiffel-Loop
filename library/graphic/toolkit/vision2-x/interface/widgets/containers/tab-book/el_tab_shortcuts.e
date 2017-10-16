note
	description: "[
		Base class for notebooks
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_TAB_SHORTCUTS

inherit
	EL_MODULE_KEY

	EL_MODULE_GUI

feature {NONE} -- Initialization

	init_keyboard_shortcuts (a_window: EV_WINDOW)
		local
			shortcuts: EL_KEYBOARD_SHORTCUTS
			page_up_accelerator, page_down_accelerator: EV_ACCELERATOR
		do
			create shortcuts.make (a_window)
			page_up_accelerator := shortcuts.create_accelerator (Key.Key_page_up, {EL_KEY_MODIFIER_CONSTANTS}.Modifier_ctrl)
			page_down_accelerator := shortcuts.create_accelerator (Key.Key_page_down, {EL_KEY_MODIFIER_CONSTANTS}.Modifier_ctrl)
			page_up_accelerator.actions.extend (agent select_left_tab)
			page_down_accelerator.actions.extend (agent select_right_tab)
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