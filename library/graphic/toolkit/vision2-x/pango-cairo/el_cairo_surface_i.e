note
	description: "Cairo drawing surface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-13 9:33:13 GMT (Monday 13th July 2020)"
	revision: "1"

deferred class
	EL_CAIRO_SURFACE_I

inherit
	EL_OWNED_C_OBJECT
		export
			{EL_SHARED_CAIRO_API} self_ptr, dispose
		end

	EL_SHARED_CAIRO_API

feature {NONE} -- Initialization

	make_argb_32 (a_width, a_height: INTEGER)
		do
			make_from_pointer (Cairo.new_image_surface (Cairo.Format_ARGB_32, a_width, a_height))
		end

	make_from_file (file_path: EL_FILE_PATH)
		require
			exists: file_path.exists
		local
			cairo_file: EL_PNG_IMAGE_FILE
		do
			if file_path.exists then
				create cairo_file.make_open_read (file_path)
				make_from_pointer (cairo_file.read_cairo_surface)
				cairo_file.close
			end
		ensure
			initialized: is_initialized
		end

	make_rgb_24 (a_width, a_height: INTEGER)
		do
			make_from_pointer (Cairo.new_image_surface (Cairo.Format_RGB_24, a_width, a_height))
		end

	make_with_argb_32_data (pixel_data: POINTER; a_width, a_height: INTEGER)
		do
			make_with_data (pixel_data, Cairo.Format_ARGB_32, a_width, a_height)
		end

	make_with_buffer (buffer: EV_PIXEL_BUFFER)
		deferred
		end

	make_with_data (pixel_data: POINTER; a_format, a_width, a_height: INTEGER)
		require
			valid_format: Cairo.is_valid_format (a_format)
		local
			stride: INTEGER
		do
			stride := Cairo.format_stride_for_width (a_format, a_width)
			make_from_pointer (Cairo.new_image_surface_for_data (pixel_data, a_format, a_width, a_height, stride))
		end

	make_with_rgb_24_data (pixel_data: POINTER; a_width, a_height: INTEGER)
		do
			make_with_data (pixel_data, Cairo.Format_RGB_24, a_width, a_height)
		end

feature -- Access

	data: POINTER
		do
			Result := Cairo.surface_data (self_ptr)
		end

	format: INTEGER
		do
			Result := Cairo.surface_format (self_ptr)
		end

feature -- Measurement

	height: INTEGER
		do
			Result := Cairo.surface_height (self_ptr)
		end

	width: INTEGER
		do
			Result := Cairo.surface_width (self_ptr)
		end

feature -- Status change

	set_surface_color_order
			-- swap red and blue color channels
		deferred
		end

feature -- Basic operations

	flush
		do
			Cairo.surface_flush (self_ptr)
		end

	mark_dirty
		do
			Cairo.surface_mark_dirty (self_ptr)
		end

	save_as (file_path: EL_FILE_PATH)
			-- Save as png file
		local
			file_out: EL_PNG_IMAGE_FILE
		do
			create file_out.make_open_write (file_path)
			file_out.put_image (self_ptr)
			file_out.close
		end
feature -- Status query

	is_initialized: BOOLEAN
		do
			Result := is_attached (self_ptr)
		end

feature {EL_DRAWABLE_CAIRO_CONTEXT_I} -- Implementation

	c_free (this: POINTER)
		do
			Cairo.destroy_surface (this)
		end

	new_context: POINTER
		do
			Result := Cairo.new_cairo (self_ptr)
		end

end
