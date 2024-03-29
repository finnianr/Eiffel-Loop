note
	description: "X11 default display"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 10:57:39 GMT (Sunday 7th January 2024)"
	revision: "4"

class
	EL_X11_DISPLAY

inherit
	EL_OWNED_C_OBJECT
		export
			{EL_X11_SCREEN_RESOURCES} self_ptr
		end

	EL_X11_C_API

create
	make

feature {NONE} -- Initialization

	make
		do
			make_from_pointer (X11_open_display (Default_pointer))
		end

feature -- Access

	default_root_window: INTEGER
		do
			Result := root_window (default_screen)
		end

	default_screen: INTEGER
		-- number of default screen
		do
			Result := X11_default_screen (self_ptr)
		end

	default_screen_resources: EL_X11_SCREEN_RESOURCES
		do
			create Result.make (Current)
		end

	default_window_image (x, y, height, width: INTEGER): EL_X11_IMAGE
		-- image rectangle of screen identified by `root_window_id'
		do
			create Result.make (
				X11_get_image (self_ptr, default_root_window, x, y, height.to_natural_32, width.to_natural_32)
			)
		end

	pixel_color (x, y: INTEGER): EL_X11_COLOR
		-- color of pixel on screen identified by `default_screen'
		-- From https://rosettacode.org/wiki/Color_of_a_screen_pixel#C
		do
			Result := default_window_image (x, y, 1, 1).pixel_color (0, 0)
			X11_query_color_rgb (self_ptr, Result.self_ptr, default_screen)
		end

	root_window (number: INTEGER): INTEGER
		do
			Result := X11_root_window (self_ptr, number)
		end

feature {NONE} -- Implementation

	c_free (this: POINTER)
		local
			status: INTEGER
		do
			status := X11_close_display (this)
		end

end