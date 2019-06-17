note
	description: "Progress button box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-16 9:51:59 GMT (Sunday 16th June 2019)"
	revision: "2"

class
	EL_PROGRESS_BUTTON_BOX [B -> EV_BUTTON create make_with_text_and_action end]

inherit
	EL_VERTICAL_BOX
		rename
			item as item_widget
		end

	EL_PROGRESS_TRACKER
		rename
			track_progress as do_track_progress
		undefine
			copy, default_create, is_equal
		end

	EL_MODULE_GUI undefine copy, default_create, is_equal end

	EL_MODULE_SCREEN undefine copy, default_create, is_equal end

	EL_MODULE_PIXMAP undefine copy, default_create, is_equal end

	EL_MODULE_SCREEN undefine copy, default_create, is_equal end

	EL_PROGRESS_DISPLAY undefine copy, default_create, is_equal end

create
	make_with_text_and_action, make_with_tick_count

feature {NONE} -- Initialization

	make_with_text_and_action (a_text: READABLE_STRING_GENERAL; an_action: PROCEDURE)
		do
			default_create
			create item.make_with_text_and_action (a_text, an_action)
			extend_unexpanded (item)
		end

	make_with_tick_count (a_text: READABLE_STRING_GENERAL; an_action: PROCEDURE; tick_count: FUNCTION [INTEGER])
		do
			make_with_text_and_action (a_text, agent track_progress (an_action, tick_count))
		end

feature -- Access

	item: B

feature -- Basic operations

	simulate_select
		do
			item.select_actions.call ([])
		end

	locate_pointer
		do
			Screen.set_pointer_position (item.screen_x + item.width, item.screen_y + item.height // 2)
		end

	track_progress (an_action: PROCEDURE; tick_count: FUNCTION [INTEGER])
		do
			parent.set_pointer_style (Pixmap.Busy_cursor)
			tick_count.apply
			do_track_progress (new_listener (Current, tick_count.last_result), an_action, agent do_nothing)
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
