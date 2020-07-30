note
	description: "Unix implemenation of [$source CAIRO_PANGO_LAYOUT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-30 12:41:15 GMT (Thursday 30th July 2020)"
	revision: "7"

class
	CAIRO_PANGO_LAYOUT_API

inherit
	CAIRO_PANGO_LAYOUT_I
		rename
			default_create as make
		end

	CAIRO_GTK2_API
		rename
			default_create as make
		end

create
	make

feature -- Factory

	frozen new_layout (context_ptr: POINTER): POINTER
			-- PangoLayout * pango_cairo_create_layout (cairo_t *cr);
		external
			"C signature (cairo_t *): EIF_POINTER use <pango/pangocairo.h>"
		alias
			"pango_cairo_create_layout"
		end

feature -- Element change

	frozen update_layout (context_ptr, layout: POINTER)
			-- void pango_cairo_update_layout (cairo_t *cr, PangoLayout *layout);
		external
			"C signature (cairo_t *, PangoLayout *) use <pango/pangocairo.h>"
		alias
			"pango_cairo_update_layout"
		end

feature -- Basic operations

	frozen show_layout (context_ptr, layout: POINTER)
			-- void pango_cairo_show_layout (cairo_t *cr, PangoLayout *layout);
		external
			"C signature (cairo_t *, PangoLayout *) use <pango/pangocairo.h>"
		alias
			"pango_cairo_show_layout"
		end

end
