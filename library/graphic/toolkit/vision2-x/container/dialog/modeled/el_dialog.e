note
	description: "Dialog to implement [$source EL_MODELED_DIALOG]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 8:09:05 GMT (Saturday 11th June 2022)"
	revision: "2"

class
	EL_DIALOG

inherit
	EV_DIALOG
		redefine
			show_modal_to_window
		end

create
	make

feature {NONE} -- Initialization

	make (a_model: EL_DIALOG_MODEL)
		do
			model := a_model
			default_create
			if a_model.has_title then
				set_title (a_model.title)
			end
		end

feature -- Basic operations

	show_modal_to_window (a_window: EV_WINDOW)
		do
			if {PLATFORM}.is_windows then
				adjust_bottom_border (a_window)
			end
			Precursor (a_window)
		end

feature {NONE} -- Implementation

	adjust_bottom_border (a_window: EV_WINDOW)
			-- This is a workaround to a bug in Windows implementation where dialog frame bottom border is not drawn
			-- See bug report #18604
		do
			if attached {EV_UNTITLED_DIALOG} a_window as untitled then
				show_actions.extend_kamikaze (agent draw_bottom_border)
			end
		end

	current_dialog: EV_DIALOG
		do
			Result := Current
		end

	draw_bottom_border
			-- A workaround for bug #18604
		do
			if attached {EL_VERTICAL_BOX} item as box then
				box.extend_unexpanded (create {EV_CELL})
				box.last.set_minimum_height (box.border_width + 1)
				box.last.set_background_color (style.border_color)
			end
		end

feature {NONE} -- Implementation

	style: EL_DIALOG_STYLE
		do
			Result := model.style
		end

feature {NONE} -- Internal attributes

	model: EL_DIALOG_MODEL

end