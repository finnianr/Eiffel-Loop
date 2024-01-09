note
	description: "Cairo Pango API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-09 9:24:46 GMT (Tuesday 9th January 2024)"
	revision: "10"

class
	CAIRO_PANGO_API

inherit
	CAIRO_PANGO_I
		rename
			default_create as make,
			set_layout_text as pango_layout_set_text,
			font_description_free as pango_font_description_free,
			set_font_style as pango_font_description_set_style,
			set_layout_font_description as pango_layout_set_font_description,
			set_layout_width as pango_layout_set_width,
			set_font_weight as pango_font_description_set_weight,
			set_font_size as pango_font_description_set_size,
			set_font_family as pango_font_description_set_family,
			new_font_description as pango_font_description_new,
			new_font_description_from_string as pango_font_description_from_string
		end

	GTK2
		rename
			default_create as make
		end

	EL_UNIX_IMPLEMENTATION
		rename
			default_create as make
		end

create
	make

feature -- Factory

	frozen new_font (pango_context, font_description: POINTER): POINTER
		-- PangoFont * pango_context_load_font (PangoContext *context, const PangoFontDescription *desc);
		external
			"C signature (PangoContext *, const PangoFontDescription *): EIF_POINTER use <pango/pango.h>"
		alias
			"pango_context_load_font"
		end

feature -- Access

	frozen layout_indent (layout: POINTER): INTEGER
			-- int pango_layout_get_indent (PangoLayout *layout);
		external
			"C signature (PangoLayout *): EIF_INTEGER use <pango/pango.h>"
		alias
			"pango_layout_get_indent"
		end

	layout_pango_size (layout: POINTER): TUPLE [width, height: INTEGER]
			-- size scaled by PANGO_SCALE
		local
			width, height: INTEGER
		do
			pango_layout_get_size (layout, $width, $height)
			Result := [width, height]
		end

	layout_size (layout: POINTER): TUPLE [width, height: INTEGER]
		local
			width, height: INTEGER
		do
			pango_layout_get_pixel_size (layout, $width, $height)
			Result := [width, height]
		end

	frozen layout_text (layout: POINTER): POINTER
			-- const char * pango_layout_get_text (PangoLayout *layout);
		external
			"C signature (PangoLayout *): EIF_POINTER use <pango/pango.h>"
		alias
			"pango_layout_get_text"
		end

	frozen layout_unknown_glyphs_count (layout: POINTER): INTEGER
			-- int pango_layout_get_unknown_glyphs_count (PangoLayout *layout);
		external
			"C signature (PangoLayout *): EIF_INTEGER use <pango/pango.h>"
		alias
			"pango_layout_get_unknown_glyphs_count"
		end

feature -- Element change

	frozen set_context_font_description (context, font_description: POINTER)
		-- void pango_context_set_font_description (PangoContext *context, const PangoFontDescription *desc);
		external
			"C signature (PangoContext *, PangoFontDescription *) use <pango/pango.h>"
		alias
			"pango_context_set_font_description"
		end

	frozen set_font_absolute_size (font_description: POINTER; size: DOUBLE)
			-- void pango_font_description_set_absolute_size (PangoFontDescription *desc, double size);
		external
			"C signature (PangoFontDescription *, double) use <pango/pango.h>"
		alias
			"pango_font_description_set_absolute_size"
		end

	frozen set_font_stretch (font_description: POINTER; value: INTEGER)
			-- void pango_font_description_set_stretch (PangoFontDescription *desc, PangoStretch stretch);
		external
			"C signature (PangoFontDescription *, PangoStretch) use <pango/pango.h>"
		alias
			"pango_font_description_set_stretch"
		end

end