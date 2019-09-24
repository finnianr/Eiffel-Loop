note
	description: "Widget progress box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-24 8:14:10 GMT (Tuesday   24th   September   2019)"
	revision: "3"

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
			finish; remove
		end

	set_progress (proportion: DOUBLE)
		local
			l_pixmap: EV_PIXMAP
		do
			create l_pixmap.make_with_size (width, Screen.vertical_pixels (0.1))
			l_pixmap.set_foreground_color (foreground_color)
			l_pixmap.fill_rectangle (0, 0, (l_pixmap.width * proportion).rounded, l_pixmap.height)
			if count = 1 then
				extend_unexpanded (l_pixmap)
			else
				finish; replace (l_pixmap)
			end
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
end
