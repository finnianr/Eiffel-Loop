note
	description: "X11 default display"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-12 15:14:19 GMT (Monday 12th October 2020)"
	revision: "1"

class
	EL_X11_DISPLAY

inherit
	EL_OWNED_C_OBJECT
		export
			{EL_X11_SCREEN_RESOURCES} self_ptr
		end

	EL_X11_API

create
	make

feature {NONE} -- Initialization

	make
		do
			make_from_pointer (X11_open_display (Default_pointer))
		end

feature -- Access

	default_screen: INTEGER
		do
			Result := X11_default_screen (self_ptr)
		end

	root_window_number: INTEGER
		do
			Result := X11_root_window (self_ptr, default_screen)
		end

	root_screen_resources: EL_X11_SCREEN_RESOURCES
		do
			create Result.make (Current)
		end

	root_window_image (x, y, height, width: INTEGER): EL_X11_IMAGE
		do
			create Result.make (x11_get_image (self_ptr, root_window_number, x, y, height.to_natural_32, width.to_natural_32))
		end

	pixel_color (x, y: INTEGER): EL_X11_COLOR
		-- From https://rosettacode.org/wiki/Color_of_a_screen_pixel#C
		do
			Result := root_window_image (x, y, 1, 1).pixel_color (0, 0)
			X11_query_color_rgb (self_ptr, Result.self_ptr, default_screen)
		end

feature {NONE} -- Implementation

	c_free (this: POINTER)
		local
			status: INTEGER
		do
			status := X11_close_display (this)
		end

end