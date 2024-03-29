note
	description: "Class for converting SVG into different formats"
	notes: "[
		Not 100% reliable on Windows for rendering SVG.
		For some reason the installed finalized version of My Ching would crash during graphic
		initialization from SVG. Class EL_PNG_IMAGE_FILE is more reliable for SVG rendering and
		is used instead.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "15"

class
	EL_SVG_IMAGE

inherit
	CAIRO_OWNED_G_OBJECT

	EL_SHARED_IMAGE_UTILS_API

create
	make

feature {NONE} -- Initialization

	make (svg_uri: EL_FILE_URI_PATH; svg_utf_8_xml: STRING)
		do
			make_from_pointer (Image_utils.rsvg_new_image (Image_utils.new_svg_image_data (svg_uri, svg_utf_8_xml)))
			create background_color.make_transparent
			create dimension_data.make (c_sizeof_dimension_data)
			c_set_width (dimension_data.item, Undefined_dimension)
			c_set_height (dimension_data.item, Undefined_dimension)
		end

feature -- Access

	background_color: EL_COLOR

	height: INTEGER
		do
			Result := c_dimension_height (dimension_data.item)
		end

	width: INTEGER
		do
			Result := c_dimension_width (dimension_data.item)
		end

feature -- Conversion

	to_drawing_area: CAIRO_DRAWING_AREA
		require
			height_and_width_defined: dimensions_defined
		do
			create Result.make_with_svg_image (Current, background_color)
		end

	to_pixmap: EL_PIXMAP
		require
			height_and_width_defined: dimensions_defined
		do
			Result:= to_drawing_area.to_pixmap
		end

feature -- Element change

	set_background_color (a_background_color: like background_color)
		do
			background_color := a_background_color
		end

	set_height (a_height: INTEGER)
		do
			Image_utils.rsvg_set_dimensions (self_ptr, dimension_data.item, Undefined_dimension, a_height)
		end

	set_width (a_width: INTEGER)
		do
			Image_utils.rsvg_set_dimensions (self_ptr, dimension_data.item, a_width, Undefined_dimension)
		end

feature -- Status query

	dimensions_defined: BOOLEAN
		do
			Result := width > 0 and height > 0
		end

	render_succeeded: BOOLEAN

feature -- Basic operations

	render (cairo_ctx: CAIRO_DRAWING_CONTEXT_I)
		require
			dimensions_defined: dimensions_defined
			pixel_buffer_correct_size: cairo_ctx.width = width and cairo_ctx.height = height
		do
			render_succeeded := False
			render_succeeded := Image_utils.rsvg_render_to_cairo (self_ptr, cairo_ctx.context)
		end

feature {NONE} -- Internal attributes

	dimension_data: MANAGED_POINTER

feature {NONE} -- C Externals

	frozen c_dimension_height (dimension: POINTER): INTEGER_32
		external
			"C [struct <rsvg.h>] (RsvgDimensionData): EIF_INTEGER"
		alias
			"height"
		end

	frozen c_dimension_width (dimension: POINTER): INTEGER_32
		external
			"C [struct <rsvg.h>] (RsvgDimensionData): EIF_INTEGER"
		alias
			"width"
		end

	frozen c_set_height (dimension: POINTER; a_height: INTEGER_32)
		external
			"C [struct <rsvg.h>] (RsvgDimensionData, int)"
		alias
			"height"
		end

	frozen c_set_width (dimension: POINTER; a_width: INTEGER_32)
		external
			"C [struct <rsvg.h>] (RsvgDimensionData, int)"
		alias
			"width"
		end

	frozen c_sizeof_dimension_data: INTEGER_32
		external
			"C macro use <rsvg.h>"
		alias
			"sizeof(RsvgDimensionData)"
		end

feature {NONE} -- Constants

	Undefined_dimension: INTEGER = -1
end