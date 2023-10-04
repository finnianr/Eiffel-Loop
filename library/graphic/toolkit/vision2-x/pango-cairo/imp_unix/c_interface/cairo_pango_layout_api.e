note
	description: "Unix implemenation of [$source CAIRO_PANGO_LAYOUT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	CAIRO_PANGO_LAYOUT_API

inherit
	CAIRO_PANGO_LAYOUT_I
		rename
			default_create as make
		end

create
	make

feature -- Factory

	frozen new (context_ptr: POINTER): POINTER
			-- PangoLayout * pango_cairo_create_layout (cairo_t *cr);
		external
			"C signature (cairo_t *): EIF_POINTER use <pango/pangocairo.h>"
		alias
			"pango_cairo_create_layout"
		end

	frozen new_pango_context (context_ptr: POINTER): POINTER
			-- PangoContext *pango_cairo_create_context (cairo_t *cr);
		external
			"C signature (cairo_t *): EIF_POINTER use <pango/pangocairo.h>"
		alias
			"pango_cairo_create_context"
		end

	frozen new_default_font_map: POINTER
		-- PangoFontMap *pango_cairo_font_map_get_default (void);
		external
			"C signature (): EIF_POINTER use <pango/pangocairo.h>"
		alias
			"pango_cairo_font_map_get_default"
		end

feature -- Element change

	frozen update (context_ptr, layout: POINTER)
			-- void pango_cairo_update_layout (cairo_t *cr, PangoLayout *layout);
		external
			"C signature (cairo_t *, PangoLayout *) use <pango/pangocairo.h>"
		alias
			"pango_cairo_update_layout"
		end

feature -- Basic operations

	frozen show (context_ptr, layout: POINTER)
			-- void pango_cairo_show_layout (cairo_t *cr, PangoLayout *layout);
		external
			"C signature (cairo_t *, PangoLayout *) use <pango/pangocairo.h>"
		alias
			"pango_cairo_show_layout"
		end

end
