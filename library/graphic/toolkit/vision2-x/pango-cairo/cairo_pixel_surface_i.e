note
	description: "Cairo readonly pixel buffer source surface"
	notes: "[
		This is a temporary object for rendering a pixmap. You must call destroy after use
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 14:33:10 GMT (Friday 31st July 2020)"
	revision: "5"

deferred class
	CAIRO_PIXEL_SURFACE_I

inherit
	CAIRO_SURFACE_I

	EL_ORIENTATION_ROUTINES
		export
			{NONE} all
			{ANY} is_valid_dimension
		end

feature {NONE} -- Initialization

	make_with_pixmap (a_pixmap: EV_PIXMAP)
		deferred
		ensure
			initialized: is_initialized
		end

	make_with_scaled_buf (dimension: NATURAL_8; buffer: EL_PIXEL_BUFFER; size: DOUBLE)
		require
			valid_dimension: is_valid_dimension (dimension)
		deferred
		ensure
			initialized: is_initialized
		end

	make_with_scaled_buffer (dimension: NATURAL_8; buffer: EL_DRAWABLE_PIXEL_BUFFER; size: DOUBLE)
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

	destroy
		deferred
		end
end
