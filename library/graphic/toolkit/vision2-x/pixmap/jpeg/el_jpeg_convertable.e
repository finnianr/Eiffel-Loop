note
	description: "Pixmap or buffer that is convertable to JPEG image that can be saved to file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-29 14:09:40 GMT (Sunday 29th May 2022)"
	revision: "8"

deferred class
	EL_JPEG_CONVERTABLE

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

feature -- Basic operations

	save_as_jpeg (file_path: FILE_PATH; quality: NATURAL)
		require
			percentage: 0 <= quality and quality <= 100
		do
			if attached to_pixel_surface as surface then
				surface.save_as_jpeg (file_path, quality)
				surface.destroy
			end
		end

feature -- Conversion

	to_pixel_surface: CAIRO_PIXEL_SURFACE_I
		deferred
		end

end