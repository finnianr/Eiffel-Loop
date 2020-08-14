note
	description: "[
		Base class for notebooks
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-12 16:34:35 GMT (Wednesday 12th August 2020)"
	revision: "5"

deferred class
	EL_TAB_SHORTCUTS

inherit
	EV_ANY_HANDLER

	EL_KEY_MODIFIER_CONSTANTS
		export
			{NONE} all
		end

	EL_MODULE_KEY

	EL_MODULE_GUI

feature {NONE} -- Initialization

	init_keyboard_shortcuts (a_window: EV_POSITIONABLE)
		local
			shortcuts: EL_KEYBOARD_SHORTCUTS
		do
			if attached {EV_WINDOW} a_window as w then
				create shortcuts.make (w)
			elseif attached {EL_VIEW_DIALOG} a_window as view then
				create shortcuts.make (view.internal_dialog)
			end
			if attached shortcuts as s then
				s.create_accelerator (Key.Key_page_up, Modifier_ctrl).actions.extend (agent select_left_tab)
				s.create_accelerator (Key.Key_page_down, Modifier_ctrl).actions.extend (agent select_right_tab)
			end
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
