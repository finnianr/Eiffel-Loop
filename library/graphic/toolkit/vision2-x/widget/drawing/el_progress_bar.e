note
	description: "Progress bar"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-16 13:40:39 GMT (Sunday 16th August 2020)"
	revision: "1"

class
	EL_PROGRESS_BAR

inherit
	EV_DRAWING_AREA
		export
			{NONE} all
			{ANY} set_foreground_color, set_background_color, clear
		end

	EL_PROGRESS_DISPLAY undefine copy, default_create, is_equal end

	EL_MODULE_GUI

	EL_MODULE_SCREEN

create
	make, make_size

feature {NONE} -- Initialization

	make (a_width, a_height: INTEGER)
		do
			default_create
			set_minimum_size (a_width, a_height)
			expose_actions.extend (agent on_redraw_progress)
		end

	make_size (a_width_cms, a_height_cms: REAL)
		do
			make (Screen.horizontal_pixels (a_width_cms), Screen.vertical_pixels (a_height_cms))
		end

feature -- Status change

	reset
		do
			proportion_filled := zero
			redraw
		end

feature -- Status query

	reset_on_finish: BOOLEAN
		-- progress bar is cleared on finish when `True'

feature -- Status change

	enable_reset_on_finish
		do
			reset_on_finish := True
		end

feature {EL_PROGRESS_DISPLAY} -- Event handling

	on_finish
		do
			if reset_on_finish then
				reset
			end
		end

	on_start (bytes_per_tick: INTEGER)
		do
			proportion_filled := zero
		end

	on_redraw_progress (a_x, a_y, a_width, a_height: INTEGER)
		do
			if proportion_filled = zero then
				clear
			else
				fill_rectangle (0, 0, (width * proportion_filled).rounded, height)
			end
		end

feature {EL_PROGRESS_DISPLAY} -- Implementation

	set_progress (proportion: DOUBLE)
		do
			proportion_filled := proportion
			redraw
			GUI.application.process_events
		end

	set_identified_text (id: INTEGER; a_text: ZSTRING)
		do
		end

feature {NONE} -- Internal attributes

	proportion_filled: DOUBLE

feature {NONE} -- Constants

	Zero: DOUBLE = 0.0

end
