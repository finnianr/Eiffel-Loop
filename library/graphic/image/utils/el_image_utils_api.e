note
	description: "Summary description for {EL_MODULE_SVG_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-07-06 18:54:58 GMT (Monday 6th July 2015)"
	revision: "5"

class
	EL_IMAGE_UTILS_API

inherit
	EL_DYNAMIC_MODULE
		redefine
			make, unload
		end

	EL_IMAGE_UTILS_C_API
		undefine
			dispose
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			if is_initialized then
				rsvg_initialize
			end
		end

feature -- Basic operations

	convert_svg_to_png (svg_in_path, png_out_path: POINTER; width, height, background_color: INTEGER): BOOLEAN
		do
			Result := el_image_convert_svg_to_png (pointer_convert_svg_to_png, svg_in_path, png_out_path, width, height, background_color)
		end

	format_argb_to_abgr (image_data: POINTER; size: INTEGER)
			-- Swap red and blue color channels
		do
			el_image_format_ARGB_to_ABGR (pointer_format_argb_to_abgr, image_data, size)
		end

	render_svg (svg_image, eiffel_write_procedure: POINTER; width, height, background_color: INTEGER): BOOLEAN
		do
			Result := el_image_render_svg (pointer_render_svg, svg_image, eiffel_write_procedure, width, height, background_color)
		end

feature -- Factory

	new_svg_image_data (svg_uri: EL_FILE_URI_PATH; svg_utf_8_xml: STRING): MANAGED_POINTER
		local
			encoded_uri: EL_URL_STRING
			base_uri, xml: POINTER
		do
			encoded_uri := svg_uri.to_encoded_utf_8
			base_uri := encoded_uri.area.base_address
			xml := svg_utf_8_xml.area.base_address
			create Result.make (c_sizeof_svg_image_t)
			c_set_svg_base_uri (Result.item, base_uri)
			c_set_svg_data (Result.item, xml)
			c_set_svg_data_count (Result.item, svg_utf_8_xml.count.to_natural_32)
		end

feature -- Cairo operations

	read_cairo_image (file_read_callback: POINTER): POINTER
		do
			Result := el_image_read_cairo_image (pointer_read_cairo_image, file_read_callback)
		end

	save_cairo_image (image, file_write_callback: POINTER)
		local
			call_status: INTEGER
		do
			call_status := el_image_save_cairo_image (pointer_save_cairo_image, image, file_write_callback)
		end

feature -- RSVG operations

	rsvg_new_image (svg_image: MANAGED_POINTER): POINTER
		do
			Result := c_rsvg_new_image (pointer_rsvg_new_image, svg_image.item)
		end

	rsvg_render_to_cairo (handle, cairo_ctx: POINTER): BOOLEAN
		do
			Result := c_rsvg_render_to_cairo (pointer_rsvg_render_to_cairo, handle, cairo_ctx)
		end

	rsvg_set_dimensions (handle, dimensions: POINTER; width, height: INTEGER)
		do
			c_rsvg_set_dimensions (pointer_rsvg_set_dimensions, handle, dimensions, width, height)
		end

feature {NONE} -- Implementation

	assign_pointers
		do
			pointer_convert_svg_to_png :=  function_pointer ("convert_svg_to_png")
			pointer_format_argb_to_abgr := function_pointer ("format_ARGB_to_ABGR")
			pointer_render_svg := function_pointer ("render_svg")

			pointer_rsvg_initialize := function_pointer ("rsvg_initialize")
			pointer_rsvg_new_image := function_pointer ("rsvg_new_image")
			pointer_rsvg_render_to_cairo := function_pointer ("rsvg_render_to_cairo")
			pointer_rsvg_set_dimensions := function_pointer ("rsvg_set_dimensions")
			pointer_rsvg_terminate := function_pointer ("rsvg_terminate")

			pointer_save_cairo_image := function_pointer ("save_cairo_image")
			pointer_read_cairo_image := function_pointer ("read_cairo_image")
		end

	rsvg_initialize
		do
			c_rsvg_initialize (pointer_rsvg_initialize)
		end

	rsvg_terminate
		do
			c_rsvg_terminate (pointer_rsvg_terminate)
		end

	unload
		do
			if is_initialized then
				rsvg_terminate
			end
			Precursor
		end

feature {NONE} -- Internal attributes

	pointer_convert_svg_to_png: POINTER

	pointer_format_argb_to_abgr: POINTER

	pointer_read_cairo_image: POINTER

	pointer_render_svg: POINTER

	pointer_rsvg_initialize: POINTER

	pointer_rsvg_new_image: POINTER

	pointer_rsvg_render_to_cairo: POINTER

	pointer_rsvg_set_dimensions: POINTER

	pointer_rsvg_terminate: POINTER

	pointer_save_cairo_image: POINTER

feature -- Constants

	Module_name: STRING = "elimageutils"

	Name_prefix: STRING = "el_image_"

	Undefined_dimension: INTEGER = -1

end
