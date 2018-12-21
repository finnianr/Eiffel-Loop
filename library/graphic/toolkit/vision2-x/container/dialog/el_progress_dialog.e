note
	description: "Progress dialog"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

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

	EL_MODULE_VISION_2
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

			label := Vision_2.new_label_with_font (label_text, a_font)

			default_create
		end

	initialize
		local
			frame: EL_FRAME [EL_VERTICAL_BOX]
		do
			Precursor

			frame := Vision_2.new_vertical_framed_box (0.4, 0.2, "", << label, progress_bar >>)
			frame.set_style (GUI.Ev_frame_raised)

			extend (Vision_2.new_vertical_box (0.15, 0, << frame >>))
		end

feature {NONE} -- Implementation

	notify
		do
			progress_bar.step_forward
		end

	progress_bar: EV_HORIZONTAL_PROGRESS_BAR

	label: EV_LABEL

end
