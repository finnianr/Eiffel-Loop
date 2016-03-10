note
	description: "Summary description for {EL_PANGO_CAIRO_C_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_PANGO_CAIRO_C_API

inherit
	EL_MEMORY

feature -- Factory

	pango_cairo_create_layout (fn_ptr, context_ptr: POINTER): POINTER
			-- PangoLayout * pango_cairo_create_layout (cairo_t *cr);
		require
			fn_ptr_attached: is_attached (fn_ptr)
		external
			"C inline use <pango/pangocairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(PangoLayout *, (cairo_t *))$fn_ptr
				) (
					(cairo_t *)$context_ptr
				)
			]"
		end

feature -- Element change

	pango_cairo_update_layout (fn_ptr, context_ptr, layout: POINTER)
			-- void pango_cairo_update_layout (cairo_t *cr, PangoLayout *layout);
		require
			fn_ptr_attached: is_attached (fn_ptr)
		external
			"C inline use <pango/pangocairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, PangoLayout *))$fn_ptr
				) (
					(cairo_t *)$context_ptr, (PangoLayout *)$layout
				)
			]"
		end

feature -- Basic operations

	pango_cairo_show_layout (fn_ptr, context_ptr, layout: POINTER)
			-- void pango_cairo_show_layout (cairo_t *cr, PangoLayout *layout);
		require
			fn_ptr_attached: is_attached (fn_ptr)
		external
			"C inline use <pango/pangocairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, PangoLayout *))$fn_ptr
				) (
					(cairo_t *)$context_ptr, (PangoLayout *)$layout
				)
			]"
		end

end
