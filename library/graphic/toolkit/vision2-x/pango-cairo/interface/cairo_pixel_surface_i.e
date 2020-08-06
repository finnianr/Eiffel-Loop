note
	description: "Cairo readonly pixel buffer source surface"
	notes: "[
		This is a temporary object for rendering a pixmap. You must call destroy after use
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 11:09:09 GMT (Sunday 2nd August 2020)"
	revision: "7"

deferred class
	CAIRO_PIXEL_SURFACE_I

inherit
	CAIRO_SURFACE_I

	EL_ORIENTATION_ROUTINES
		export
			{NONE} all
			{ANY} is_valid_dimension
		end

	EL_MODULE_EXCEPTION

feature {NONE} -- Initialization

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		deferred
		ensure
			initialized: is_initialized
		end

	make_with_buffer (a_buffer: EV_PIXEL_BUFFER)
		-- make with Vision-2 pixel buffer
		deferred
		ensure
			initialized: is_initialized
		end

	make_with_scaled_drawing (dimension: NATURAL_8; buffer: CAIRO_DRAWING_AREA; size: DOUBLE)
		require
			valid_dimension: is_valid_dimension (dimension)
		deferred
		ensure
			initialized: is_initialized
		end

	make_with_scaled_pixmap (dimension: NATURAL_8; other: EV_PIXMAP; size: DOUBLE)
		require
			valid_dimension: is_valid_dimension (dimension)
		deferred
		ensure
			initialized: is_initialized
		end

	make_with_size (a_width, a_height: INTEGER)
		deferred
		ensure
			initialized: is_initialized
		end

feature -- Basic operations

	adjust_colors
		-- adjust order of color channels for OS platform
		deferred
		end

	destroy
		deferred
		end

	save_as_jpeg (file_path: EL_FILE_PATH; quality: NATURAL)
		deferred
		end

end