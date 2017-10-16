note
	description: "Summary description for {EL_PANGO_CAIRO_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_PANGO_CAIRO_API

inherit
	EL_PANGO_CAIRO_I
		rename
			default_create as make
		end

	GTK2
		rename
			default_create as make
		end

create
	make

feature -- Factory

	frozen create_layout (context_ptr: POINTER): POINTER
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