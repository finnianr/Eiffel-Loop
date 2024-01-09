note
	description: "Pango Cairo Layout C API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 11:16:55 GMT (Sunday 7th January 2024)"
	revision: "12"

class
	CAIRO_PANGO_LAYOUT_C_API

inherit
	EL_C_API

	EL_WINDOWS_IMPLEMENTATION

feature -- Factory

	pango_cairo_create_context (fn_ptr, context_ptr: POINTER): POINTER
		-- PangoContext *pango_cairo_create_context (cairo_t *cr);
		require
			fn_ptr_attached: is_attached (fn_ptr)
		external
			"C inline use <pango/pangocairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(PangoContext *, (cairo_t *))$fn_ptr
				) (
					(cairo_t *)$context_ptr
				)
			]"
		end

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

	pango_cairo_font_map_get_default (fn_ptr: POINTER): POINTER
		-- PangoFontMap *pango_cairo_font_map_get_default (void);
		require
			fn_ptr_attached: is_attached (fn_ptr)
		external
			"C inline use <pango/pangocairo.h>"
		alias
			"[
				return (FUNCTION_CAST(PangoFontMap *, ())$fn_ptr) ()
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