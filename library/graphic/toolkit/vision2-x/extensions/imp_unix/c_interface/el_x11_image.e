note
	description: "[
		Owned [https://tronche.com/gui/x/xlib/graphics/images.html#XImage XImage structure]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 10:57:39 GMT (Sunday 7th January 2024)"
	revision: "3"

class
	EL_X11_IMAGE

inherit
	EL_OWNED_C_OBJECT
		rename
			c_free as X11_free,
			make_from_pointer as make
		end

	EL_X11_C_API

create
	make

feature -- Access

	pixel_color (x, y: INTEGER): EL_X11_COLOR
		do
			create Result.make
			Result.set_pixel (image_pixel (x, y))
		end

	image_pixel (x, y: INTEGER): NATURAL
		do
			Result := X11_get_image_pixel (self_ptr, x, y)
		end
end