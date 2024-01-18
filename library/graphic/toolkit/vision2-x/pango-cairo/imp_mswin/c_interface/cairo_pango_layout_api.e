note
	description: "Windows implemenation of ${CAIRO_PANGO_LAYOUT_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 11:31:16 GMT (Tuesday 9th January 2024)"
	revision: "12"

class
	CAIRO_PANGO_LAYOUT_API

inherit
	EL_DYNAMIC_MODULE [CAIRO_PANGO_LAYOUT_API_POINTERS]

	CAIRO_PANGO_LAYOUT_I

	CAIRO_PANGO_LAYOUT_C_API

	EL_WINDOWS_IMPLEMENTATION

create
	make

feature -- Factory

	new (context_ptr: POINTER): POINTER
		do
			Result := pango_cairo_create_layout (api.create_layout, context_ptr)
		end

	new_pango_context (context_ptr: POINTER): POINTER
		do
			Result := pango_cairo_create_context (api.create_context, context_ptr)
		end

	new_default_font_map: POINTER
		do
			Result := pango_cairo_font_map_get_default (api.font_map_get_default)
		end

feature -- Basic operations

	show (context_ptr, layout: POINTER)
		do
			pango_cairo_show_layout (api.show_layout, context_ptr, layout)
		end

	update (context_ptr, layout: POINTER)
		do
			pango_cairo_update_layout (api.update_layout, context_ptr, layout)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libpangocairo-1.0-0"

	Name_prefix: STRING = "pango_cairo_"

note
	library_functions: "[
		dumpbin /EXPORTS Cairo-1.12.16\spec\win64\libpangocairo-1.0-0.dll

		 1    0 00001D27 pango_cairo_context_get_font_options
		 2    1 00001BB5 pango_cairo_context_get_resolution
		 3    2 00001F58 pango_cairo_context_get_shape_renderer
		 4    3 00001BF8 pango_cairo_context_set_font_options
		 5    4 00001B85 pango_cairo_context_set_resolution
		 6    5 00001E6A pango_cairo_context_set_shape_renderer
		 7    6 0000203B pango_cairo_create_context
		 8    7 0000209E pango_cairo_create_layout
		 9    8 00007018 pango_cairo_error_underline_path = pango_font_description_free
		10    9 0000287B pango_cairo_font_get_scaled_font
		11    A 000024E1 pango_cairo_font_get_type
		12    B 000048D0 pango_cairo_font_map_create_context
		13    C 00004672 pango_cairo_font_map_get_default
		14    D 0000496B pango_cairo_font_map_get_font_type
		15    E 0000481D pango_cairo_font_map_get_resolution
		16    F 00004561 pango_cairo_font_map_get_type
		17   10 00004628 pango_cairo_font_map_new
		18   11 00004644 pango_cairo_font_map_new_for_font_type
		19   12 000046B3 pango_cairo_font_map_set_default
		20   13 00004764 pango_cairo_font_map_set_resolution
		21   14 00006E67 pango_cairo_glyph_string_path
		22   15 00006EE0 pango_cairo_layout_line_path
		23   16 00006F4E pango_cairo_layout_path
		24   17 00004A64 pango_cairo_renderer_get_type
		25   18 00006DAE pango_cairo_show_error_underline
		26   19 00006BDA pango_cairo_show_glyph_item
		27   1A 00006B61 pango_cairo_show_glyph_string
		28   1B 00006CE4 pango_cairo_show_layout
		29   1C 00006C76 pango_cairo_show_layout_line
		30   1D 00001AC1 pango_cairo_update_context
		31   1E 00002101 pango_cairo_update_layout
		32   1F 00007DD5 pango_cairo_win32_font_map_get_type
	]"
end