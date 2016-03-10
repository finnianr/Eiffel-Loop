note
	description: "Summary description for {EL_CAIRO_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_CAIRO_C_API

inherit
	EL_MEMORY

feature -- Access

	frozen cairo_get_antialias (function, context: POINTER): INTEGER
			-- cairo_antialias_t cairo_get_antialias (cairo_t *cr);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(cairo_antialias_t, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_image_surface_get_data (function, surface: POINTER): POINTER
			-- unsigned char * cairo_image_surface_get_data (cairo_surface_t *surface);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(unsigned char *, (cairo_surface_t *))$function
				) (
					(cairo_surface_t *)$surface
				)
			]"
		end

	frozen cairo_image_surface_get_format (function, surface: POINTER): INTEGER
			-- cairo_format_t cairo_image_surface_get_format (cairo_surface_t *surface);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(cairo_format_t, (cairo_surface_t *))$function
				) (
					(cairo_surface_t *)$surface
				)
			]"
		end

	frozen cairo_image_surface_get_height (function, surface: POINTER): INTEGER
			-- int cairo_image_surface_get_height (cairo_surface_t *surface);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(int, (cairo_surface_t *))$function
				) (
					(cairo_surface_t *)$surface
				)
			]"
		end

	frozen cairo_image_surface_get_width (function, surface: POINTER): INTEGER
			-- int cairo_image_surface_get_width (cairo_surface_t *surface);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(int, (cairo_surface_t *))$function
				) (
					(cairo_surface_t *)$surface
				)
			]"
		end

feature -- Factory

	frozen cairo_create (function, surface_ptr: POINTER): POINTER
			-- cairo_t * cairo_create (cairo_surface_t *target);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(cairo_t *, (cairo_surface_t *))$function
				) (
					(cairo_surface_t *)$surface_ptr
				)
			]"
		end

	frozen cairo_win32_surface_create (function, hdc: POINTER): POINTER
			-- cairo_surface_t * cairo_win32_surface_create (HDC hdc);		
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(cairo_surface_t *, (HDC))$function
				) (
					(HDC)$hdc
				)
			]"
		end

	frozen cairo_image_surface_create (function: POINTER; format, width, height: INTEGER): POINTER
			-- cairo_surface_t * cairo_image_surface_create (cairo_format_t format, int width, int height);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(cairo_surface_t *, (cairo_format_t, int, int))$function
				) (
					(cairo_format_t)$format, (int)$width, (int)$height
				)
			]"
		end

	frozen cairo_image_surface_create_from_png (function, png_path: POINTER): POINTER
			-- cairo_surface_t * cairo_image_surface_create_from_png (const char *filename);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(cairo_surface_t *, (const char *))$function
				) (
					(const char *)$png_path
				)
			]"
		end

	frozen cairo_image_surface_create_for_data (function, data: POINTER; format, width, height, stride: INTEGER): POINTER
			-- cairo_surface_t * cairo_image_surface_create_for_data (
			--		unsigned char *data, cairo_format_t format, int width, int height, int stride
			-- );
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(cairo_surface_t *, (unsigned char *, cairo_format_t, int, int, int))$function
				) (
					(unsigned char *)$data, (cairo_format_t)$format, (int)$width, (int)$height, (int)$stride
				)
			]"
		end

feature -- Status setting

	frozen cairo_surface_mark_dirty (function, surface: POINTER)
			-- void	cairo_surface_mark_dirty (cairo_surface_t *surface);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_surface_t *))$function
				) (
					(cairo_surface_t *)$surface
				)
			]"
		end

	frozen cairo_reset_clip (function, context: POINTER)
			-- void cairo_reset_clip (cairo_t *cr);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"		
		end

feature -- Element change

	frozen cairo_set_antialias (function, context: POINTER; a_antialias: INTEGER)
			-- void cairo_set_antialias (cairo_t *cr, cairo_antialias_t antialias);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, cairo_antialias_t))$function
				) (
					(cairo_t *)$context, (cairo_antialias_t)$a_antialias
				)
			]"
		end

	frozen cairo_set_font_size (function, context: POINTER; size: DOUBLE)
			-- void cairo_set_font_size (cairo_t *cr, double size);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double))$function
				) (
					(cairo_t *)$context, (double)$size
				)
			]"
		end

	frozen cairo_set_line_width (function, context: POINTER; size: DOUBLE)
			-- void cairo_set_line_width (cairo_t *cr, double width);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double))$function
				) (
					(cairo_t *)$context, (double)$size
				)
			]"
		end

	frozen cairo_set_source_rgb (function, context: POINTER; red, green, blue: DOUBLE)
			-- void cairo_set_source_rgb (cairo_t *cr, double red, double green, double blue);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double, double, double))$function
				) (
					(cairo_t *)$context, (double)$red, (double)$green, (double)$blue
				)
			]"
		end

	frozen cairo_set_source_rgba (function, context: POINTER; red, green, blue, alpha: DOUBLE)
			-- void cairo_set_source_rgb (cairo_t *cr, double red, double green, double blue);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double, double, double, double))$function
				) (
					(cairo_t *)$context, (double)$red, (double)$green, (double)$blue, (double)$alpha
				)
			]"
		end

	frozen cairo_set_source_surface (function, context, surface: POINTER; x, y: DOUBLE)
			-- void cairo_set_source_surface (cairo_t *cr, cairo_surface_t *surface, double x, double y);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, cairo_surface_t *, double, double))$function
				) (
					(cairo_t *)$context, (cairo_surface_t *)$surface, (double)$x, (double)$y
				)
			]"
		end

feature -- Basic operations

	frozen cairo_arc (function, context: POINTER; xc, yc, radius, angle1, angle2: DOUBLE)
			-- void cairo_arc (cairo_t *cr, double xc, double yc, double radius, double angle1, double angle2);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double, double, double, double, double))$function
				) (
					(cairo_t *)$context, (double)$xc, (double)$yc, (double)$radius, (double)$angle1, (double)$angle2
				)
			]"
		end

	frozen cairo_clip (function, context: POINTER)
			-- void cairo_clip (cairo_t *cr);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_close_path (function, context: POINTER)
			-- void cairo_close_path (cairo_t *cr);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_new_sub_path (function, context: POINTER)
			-- void cairo_new_sub_path (cairo_t *cr);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_fill (function, context: POINTER)
			-- void cairo_fill (cairo_t *cr);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_format_stride_for_width (function: POINTER; format, width: INTEGER): INTEGER
			-- int cairo_format_stride_for_width (cairo_format_t format, int width);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(int, (cairo_format_t, int))$function
				) (
					(cairo_format_t)$format, (int)$width
				)
			]"
		end

	frozen cairo_line_to (function, context: POINTER; x, y: DOUBLE)
			-- void cairo_line_to (cairo_t *cr, double x, double y);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double, double))$function
				) (
					(cairo_t *)$context, (double)$x, (double)$y
				)
			]"
		end

	frozen cairo_move_to (function, context: POINTER; x, y: DOUBLE)
			-- void cairo_move_to (cairo_t *cr, double x, double y);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double, double))$function
				) (
					(cairo_t *)$context, (double)$x, (double)$y
				)
			]"
		end

	frozen cairo_new_path (function, context: POINTER)
			-- void cairo_new_path (cairo_t *cr);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_paint (function, context: POINTER)
			-- void cairo_paint (cairo_t *cr);
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_rectangle (function, context: POINTER; x, y, width, height: DOUBLE)
			-- void cairo_rectangle (cairo_t *cr, double x, double y, double width, double height);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double, double, double, double))$function
				) (
					(cairo_t *)$context, (double)$x, (double)$y, (double)$width, (double)$height
				)
			]"
		end

	frozen cairo_restore (function, context: POINTER)
			-- void cairo_restore (cairo_t *cr);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_rotate (function, context: POINTER; angle: DOUBLE)
			-- void cairo_rotate (cairo_t *cr, double angle);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double))$function
				) (
					(cairo_t *)$context, (double)$angle
				)
			]"
		end

	frozen cairo_save (function, context: POINTER)
			-- void cairo_save (cairo_t *cr);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_scale (function, context: POINTER; sx, sy: DOUBLE)
			-- void cairo_scale (cairo_t *cr, double sx, double sy);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double, double))$function
				) (
					(cairo_t *)$context, (double)$sx, (double)$sy
				)
			]"
		end

	frozen cairo_select_font_face (function, context, family_utf8: POINTER; slant, weight: INTEGER)
			-- void cairo_select_font_face (
			--		cairo_t *cr, const char *family, cairo_font_slant_t slant, cairo_font_weight_t weight
			-- );
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, const char *, cairo_font_slant_t, cairo_font_weight_t))$function
				) (
					(cairo_t *)$context,
					(const char *)$family_utf8, (cairo_font_slant_t)$slant, (cairo_font_weight_t)$weight
				)
			]"
		end

	frozen cairo_stroke (function, context: POINTER)
			-- void cairo_stroke (cairo_t *cr);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_surface_flush (function, surface_ptr: POINTER)
			-- void cairo_surface_flush (cairo_surface_t *surface);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_surface_t *))$function
				) (
					(cairo_surface_t*)$surface_ptr
				)
			]"
		end

	frozen cairo_show_text (function, context, text_utf8: POINTER)
			-- void cairo_show_text (cairo_t *cr, const char *utf8);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, const char *))$function
				) (
					(cairo_t *)$context, (const char *)$text_utf8
				)
			]"
		end

	frozen cairo_translate (function, context: POINTER; tx, ty: DOUBLE)
			-- void cairo_translate (cairo_t *cr, double tx, double ty);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t *, double, double))$function
				) (
					(cairo_t *)$context, (double)$tx, (double)$ty
				)
			]"
		end

feature -- C memory release

	frozen cairo_destroy (function, context: POINTER)
			-- void cairo_destroy (cairo_t *cr);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_t*))$function
				) (
					(cairo_t *)$context
				)
			]"
		end

	frozen cairo_surface_destroy (function, surface_ptr: POINTER)
			-- void cairo_surface_destroy (cairo_surface_t *surface);
		require
			fn_ptr_attached: is_attached (function)
		external
			"C inline use <cairo.h>"
		alias
			"[
				return (
					FUNCTION_CAST(void, (cairo_surface_t*))$function
				) (
					(cairo_surface_t*)$surface_ptr
				)
			]"
		end

end
