note
	description: "File for reading and writing Cairo image surfaces from PNG format graphical files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-06 18:13:31 GMT (Monday 6th July 2015)"
	revision: "5"

class
	EL_PNG_IMAGE_FILE

inherit
	RAW_FILE
		export
			{NONE} all
			{ANY} close, is_open_read, is_open_write, open_read, open_write, count
		redefine
			make_with_name
		end

	EL_SHARED_IMAGE_UTILS_API

	EL_C_CALLABLE
		rename
			make as make_callable
		end

create
	make_with_path, make_with_name, make_open_read, make_open_write

feature {NONE} -- Initialization

	make_with_name (file_path: READABLE_STRING_GENERAL)
		do
			Precursor (file_path)
			make_callable
			create data.share_from_pointer (default_pointer, 0)
		end

feature -- Basic operations

	put_image (cairo_surface: POINTER)
		require
			open_write: is_open_write
		do
			set_callback_routine ($on_append_data)
			protect_c_callbacks
			Image_utils.save_cairo_image (cairo_surface, pointer_to_c_callbacks_struct)
			unprotect_c_callbacks
		end

	read_cairo_surface: POINTER
		require
			open_read: is_open_read
		do
			set_callback_routine ($on_read_data_block)
			protect_c_callbacks
			Result := Image_utils.read_cairo_image (pointer_to_c_callbacks_struct)
			unprotect_c_callbacks
		end

	render_svg_of_width (svg_uri: EL_FILE_URI_PATH; svg_utf_8_xml: STRING; width, background_color: INTEGER)
		require
			open_write: is_open_write
		do
			render_svg (svg_uri, svg_utf_8_xml, width, Undefined_dimension, background_color)
		end

	render_svg_of_height (svg_uri: EL_FILE_URI_PATH; svg_utf_8_xml: STRING; height, background_color: INTEGER)
		require
			open_write: is_open_write
		do
			render_svg (svg_uri, svg_utf_8_xml, Undefined_dimension, height, background_color)
		end

	render_svg (svg_uri: EL_FILE_URI_PATH; svg_utf_8_xml: STRING; width, height, background_color: INTEGER)
		require
			open_write: is_open_write
			is_width_conversion: width > 0 implies height = Undefined_dimension
			is_height_conversion: height > 0 implies width = Undefined_dimension
		local
			image_data: MANAGED_POINTER
		do
			image_data := Image_utils.new_svg_image_data (svg_uri, svg_utf_8_xml)
			set_callback_routine ($on_append_data)
			protect_c_callbacks
			last_render_succeeded := Image_utils.render_svg (
				image_data.item, pointer_to_c_callbacks_struct, width, height, background_color
			)
			unprotect_c_callbacks
		ensure
			succeeded: last_render_succeeded
		end

feature -- Status query

	last_render_succeeded: BOOLEAN

feature {NONE} -- Implementation

	set_callback_routine (routine: POINTER)
		do
			Call_back_routines [1] := routine
		end

	on_append_data (data_ptr: POINTER; nb_bytes: INTEGER)
		do
			data.set_from_pointer (data_ptr, nb_bytes)
			put_managed_pointer (data, 0, nb_bytes)
		end

	on_read_data_block (is_eof_ptr, data_ptr: POINTER; nb_bytes: INTEGER)
		do
			if end_of_file then
				data.set_from_pointer (is_eof_ptr, {PLATFORM}.Integer_32_bytes)
				data.put_integer_32 (1, 0)
			else
				data.set_from_pointer (data_ptr, nb_bytes)
				read_to_managed_pointer (data, 0, nb_bytes)
			end
		end

	data: MANAGED_POINTER

feature {NONE} -- Constants

	Call_back_routines: ARRAY [POINTER]
			-- redefine with addresses of frozen procedures
		once
			Result := << default_pointer >>
		end

feature -- Constants

	Undefined_dimension: INTEGER
		once
			Result := Image_utils.Undefined_dimension
		end
end
