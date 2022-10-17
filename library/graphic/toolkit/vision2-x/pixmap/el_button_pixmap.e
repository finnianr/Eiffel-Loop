note
	description: "Button pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-17 18:22:04 GMT (Monday 17th October 2022)"
	revision: "8"

class
	EL_BUTTON_PIXMAP

inherit
	EV_PIXMAP

	EV_BUILDER

	EL_MODULE_SCREEN

	EL_MODULE_ACTION

	EL_MODULE_COLOR

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
				set_foreground_color (Color.Black)
				draw_rectangle (0, 0, width, height)
			end
		end

feature {NONE} -- Implementation

	pixmap: EV_PIXMAP

end
