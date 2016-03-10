note
	description: "Summary description for {EL_BUTTON_PIXMAP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_BUTTON_PIXMAP
inherit
	EV_PIXMAP

	EV_BUILDER

	EL_MODULE_GRAPHICS_SYSTEM
		undefine
			default_create, is_equal, copy
		end

	EL_MODULE_GUI
		undefine
			default_create, is_equal, copy
		end

create
	make_from_pixmap

feature {NONE} -- Initialization

	make_from_pixmap (a_pixmap: EV_PIXMAP)
			--
		do
			pixmap := a_pixmap
			make_with_size (pixmap.width, pixmap.height)
--			Bug doesn't work
--			make_with_pixel_buffer (create {EV_PIXEL_BUFFER}.make_with_pixmap (pixmap))

			draw
		end

feature -- Access

feature -- Status report

	is_mouse_over_button: BOOLEAN

feature -- Element change

	set_mouse_hover (flag: BOOLEAN)
		do
			is_mouse_over_button := flag
			draw; flush
		end

feature -- Basic operations

	draw
		do
			clear
			draw_pixmap (0, 0, pixmap)
			if is_mouse_over_button then
				set_line_width (3)
				set_foreground_color (GUI.Black)
				draw_rectangle (0, 0, width, height)
			end
		end

feature {NONE} -- Implementation

	pixmap: EV_PIXMAP

end
