note
	description: "Widget progress box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-15 10:18:57 GMT (Wednesday 15th July 2020)"
	revision: "4"

class
	EL_WIDGET_PROGRESS_BOX [W -> EV_WIDGET create default_create end]

inherit
	EL_VERTICAL_BOX
		rename
			make as make_box
		end

	EL_PROGRESS_DISPLAY undefine copy, default_create, is_equal end

	EL_MODULE_GUI

	EL_MODULE_SCREEN

	EL_MODULE_PIXMAP

	EL_MODULE_SCREEN

	EL_MODULE_TRACK

create
	make, make_default

feature {NONE} -- Initialization

	make (a_widget: W)
		do
			default_create
			widget := a_widget
			extend_unexpanded (a_widget)
		end

	make_default
		do
			make (create {W})
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

	remove_bar
		do
			prune (progress_bar)
			progress_bar := Void
		end

	set_progress (proportion: DOUBLE)
		local
			bar: EV_PIXMAP
		do
			if attached progress_bar as b then
				bar := b
			else
				create bar.make_with_size (width, Screen.vertical_pixels (0.1))
				bar.set_foreground_color (foreground_color)
				extend_unexpanded (bar)
				progress_bar := bar
			end
			bar.fill_rectangle (0, 0, (bar.width * proportion).rounded, bar.height)
			GUI.application.process_events
		end

feature {NONE} -- Event handling

	on_finish
		do
			GUI.do_later (agent remove_bar, 500)
		end

	on_start (bytes_per_tick: INTEGER)
		do
		end

feature {NONE} -- Implementation

	set_identified_text (id: INTEGER; a_text: ZSTRING)
		do
		end

feature {NONE} -- Internal attributes

	progress_bar: detachable EV_PIXMAP
end
