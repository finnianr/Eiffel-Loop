note
	description: "Widget progress box"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-11 13:56:14 GMT (Saturday 11th June 2022)"
	revision: "8"

class
	EL_WIDGET_PROGRESS_BOX [W -> EV_WIDGET create default_create end]

inherit
	EL_VERTICAL_BOX
		rename
			make as make_box
		end

	EL_MODULE_COLOR; EL_MODULE_GUI; EL_MODULE_SCREEN; EL_MODULE_TRACK

create
	make, make_default

feature {NONE} -- Initialization

	make (a_widget: like widget)
		do
			default_create
			widget := a_widget
			extend_unexpanded (a_widget)
			create bar.make ((widget.width * 0.92).rounded, Screen.vertical_pixels (0.1))
			bar.set_background_color (Color.face_3d)
			bar.enable_reset_on_finish

			extend_unexpanded (bar)
		end

	make_default
		do
			make (create {like widget})
		end

feature -- Access

	widget: W

	bar: EL_PROGRESS_BAR

feature -- Basic operations

	locate_pointer
		do
			Screen.set_pointer_position (widget.screen_x + widget.width, widget.screen_y + widget.height // 2)
		end

	track_progress (an_action: PROCEDURE; tick_count: FUNCTION [INTEGER])
		do
			parent.set_pointer_style (Pixmaps.Busy_cursor)
			tick_count.apply
			Track.progress (bar, tick_count.last_result, an_action)
			parent.set_pointer_style (Pixmaps.Standard_cursor)
		end

end