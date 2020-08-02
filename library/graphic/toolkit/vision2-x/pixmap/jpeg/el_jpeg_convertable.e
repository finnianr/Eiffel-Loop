note
	description: "Pixmap or buffer that is convertable to JPEG image that can be saved to file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-01 15:54:09 GMT (Saturday 1st August 2020)"
	revision: "6"

deferred class
	EL_JPEG_CONVERTABLE

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

feature -- Basic operations

	save_as_jpeg (file_path: EL_FILE_PATH; quality: NATURAL)
		require
			percentage: 0 <= quality and quality <= 100
		local
			surface: like to_pixel_surface
		do
			surface := to_pixel_surface
			surface.save_as_jpeg (file_path, quality)
			surface.destroy
		end

feature -- Conversion

	to_pixel_surface: CAIRO_PIXEL_SURFACE_I
		deferred
		end

end
