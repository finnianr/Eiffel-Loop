note
	description: "Widget progress box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-14 15:57:52 GMT (Friday 14th August 2020)"
	revision: "6"

class
	EL_WIDGET_PROGRESS_BOX [W -> EV_WIDGET create default_create end]

inherit
	EL_VERTICAL_BOX
		rename
			make as make_box
		end

	EL_PROGRESS_DISPLAY undefine copy, default_create, is_equal end

	EL_MODULE_GUI

	EL_MODULE_COLOR

	EL_MODULE_SCREEN

	EL_MODULE_PIXMAP

	EL_MODULE_SCREEN

	EL_MODULE_TRACK

create
	make, make_default

feature {NONE} -- Initialization

	make (a_widget: like widget)
		do
			default_create
			widget := a_widget
			clear_on_finish := True
			extend_unexpanded (a_widget)
			create progress_bar
			progress_bar.set_minimum_size ((widget.width * 0.92).rounded, Screen.vertical_pixels (0.1))
			progress_bar.set_background_color (Color.face_3d)
			progress_bar.expose_actions.extend (agent on_redraw_progress)

			extend_unexpanded (progress_bar)
		end

	make_default
		do
			make (create {like widget})
		end

feature -- Access

	widget: W

feature -- Basic operations

	locate_pointer
		do
			Screen.set_pointer_position (widget.screen_x + widget.width, widget.screen_y + widget.height // 2)
		end

	track_progress (an_action: PROCEDURE; tick_count: FUNCTION [INTEGER])
		do
			parent.set_pointer_style (Pixmap.Busy_cursor)
			tick_count.apply
			Track.progress (Current, tick_count.last_result, an_action)
			parent.set_pointer_style (Pixmap.Standard_cursor)
		end

feature -- Element change

	set_progress (proportion: DOUBLE)
		do
			proportion_filled := proportion
			progress_bar.redraw
			GUI.application.process_events
		end

feature -- Status query

	clear_on_finish: BOOLEAN
		-- progress bar is cleared on finish when `True'

feature -- Status change

	disable_clear_on_finish
		do
			clear_on_finish := False
		end

feature {NONE} -- Event handling

	on_finish
		do
			if clear_on_finish then
				proportion_filled := zero
				progress_bar.redraw
			end
		end

	on_redraw_progress (a_x, a_y, a_width, a_height: INTEGER)
		do
			if proportion_filled = zero then
				progress_bar.clear
				progress_bar.set_foreground_color (foreground_color)
			else
				progress_bar.fill_rectangle (0, 0, (progress_bar.width * proportion_filled).rounded, progress_bar.height)
			end
		end

	on_start (bytes_per_tick: INTEGER)
		do
			proportion_filled := zero
		end

feature {NONE} -- Implementation

	set_identified_text (id: INTEGER; a_text: ZSTRING)
		do
		end

feature {NONE} -- Internal attributes

	Zero: DOUBLE = 0.0
	progress_bar: EV_DRAWING_AREA

	proportion_filled: DOUBLE

end
