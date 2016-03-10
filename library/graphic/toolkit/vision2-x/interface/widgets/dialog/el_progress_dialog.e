note
	description: "Summary description for {EL_PROGRESS_DIALOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_PROGRESS_DIALOG

inherit
	EV_UNTITLED_DIALOG
		redefine
			initialize
		end

	EL_MODULE_GUI
		undefine
			copy, default_create
		end

	EL_EVENT_LISTENER
		undefine
			copy, default_create
		end

create
	make_dialog

feature {NONE} -- Initialization

	make_dialog (label_text: STRING; a_font: EV_FONT; range_upper: INTEGER)
		do
			create progress_bar.make_with_value_range (1 |..| range_upper)
			progress_bar.disable_segmentation
			
			label := GUI.label_with_font (label_text, a_font)

			default_create
		end

	initialize
		local
			frame: EL_FRAME [EL_VERTICAL_BOX]
		do
			Precursor

			frame := GUI.vertical_framed_box (0.4, 0.2, "", << label, progress_bar >>)
			frame.set_style (GUI.Ev_frame_raised)

			extend (GUI.vertical_box (0.15, 0, << frame >>))
		end

feature {NONE} -- Implementation

	notify
		do
			progress_bar.step_forward
		end

	progress_bar: EV_HORIZONTAL_PROGRESS_BAR

	label: EV_LABEL

end
