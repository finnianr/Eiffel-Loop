note
	description: "Control"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_CONTROL

inherit
	WEL_CONTROL
		undefine
			process_notification, default_ex_style, set_text, on_set_focus, on_kill_focus
		redefine
			on_key_down
		end

	WEL_VK_CONSTANTS

	EL_MODULE_LOG

feature {NONE} -- Initialization

	make_control (a_parent_dialog: EL_WEL_DIALOG)
			--
		do
			parent_dialog := a_parent_dialog
		end

feature {NONE} -- Event handlers

	on_key_down (virtual_key, key_data: INTEGER)
			-- Wm_keydown message.
		do
			if virtual_key = Vk_tab then
				if key_down (Vk_shift) then
					parent_dialog.tab_to_control_left (Current)
				else
					parent_dialog.tab_to_control_right (Current)
				end
			end
		end

feature {NONE} -- Implementation

	parent_dialog: EL_WEL_DIALOG

end