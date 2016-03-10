note
	description: "Summary description for {EL_CAIRO_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "4"

deferred class
	EL_CAIRO_I

inherit
	EL_MEMORY

feature -- Access

	antialias (context: POINTER): INTEGER
		require
			is_attached: is_attached (context)
		deferred
		end

	surface_data (surface: POINTER): POINTER
		require
			is_attached: is_attached (surface)
		deferred
		end

	surface_format (surface: POINTER): INTEGER
		require
			is_attached: is_attached (surface)
		deferred
		end

	surface_height (surface: POINTER): INTEGER
		require
			is_attached: is_attached (surface)
		deferred
		end

	surface_width (surface: POINTER): INTEGER
		require
			is_attached: is_attached (surface)
		deferred
		end

feature -- Status change

	surface_mark_dirty (surface: POINTER)
		require
			is_attached: is_attached (surface)
		deferred
		end

	reset_clip (context: POINTER)
		require
			is_attached: is_attached (context)
		deferred
		end

feature -- Factory

	new_cairo (surface: POINTER): POINTER
			-- cairo_t * cairo_create (cairo_surface_t *target);
		require
			is_attached: is_attached (surface)
		deferred
		end

	new_image_surface (format, width, height: INTEGER): POINTER
		deferred
		end

	new_image_surface_from_png (png_path: POINTER): POINTER
		deferred
		end

	new_image_surface_for_data (data: POINTER; format, width, height, stride: INTEGER): POINTER
			-- cairo_surface_t * cairo_image_surface_create_for_data (
			--		unsigned char *data, cairo_format_t format, int width, int height, int stride
			-- );
		deferred
		end

	new_win32_surface_create (hdc: POINTER): POINTER
		deferred
		end

feature -- Element change

	set_antialias (context: POINTER; a_antialias: INTEGER)
		require
			is_attached: is_attached (context)
		deferred
		end

	set_font_size (context: POINTER; size: DOUBLE)
			-- void cairo_set_font_size (cairo_t *cr, double size);
		require
			is_attached: is_attached (context)
		deferred
		end

	set_line_width (context: POINTER; size: DOUBLE)
		require
			is_attached: is_attached (context)
		deferred
		end

	set_source_rgb (context: POINTER; red, green, blue: DOUBLE)
			-- void cairo_set_source_rgb (cairo_t *cr, double red, double green, double blue);
		require
			is_attached: is_attached (context)
		deferred
		end

	set_source_rgba (context: POINTER; red, green, blue, alpha: DOUBLE)
			-- void cairo_set_source_rgb (cairo_t *cr, double red, double green, double blue);
		require
			is_attached: is_attached (context)
		deferred
		end

	set_source_surface (context, surface: POINTER; x, y: DOUBLE)
		require
			is_context_attached: is_attached (context)
			is_surface_attached: is_attached (surface)
		deferred
		end

feature -- Drawing operations

	arc (context: POINTER; xc, yc, radius, angle1, angle2: DOUBLE)
		require
			context_attached: is_attached (context)
		deferred
		end

	clip (context: POINTER)
		require
			context_attached: is_attached (context)
		deferred
		end

	close_sub_path (context: POINTER)
		require
			context_attached: is_attached (context)
		deferred
		end

	define_sub_path (context: POINTER)
		require
			context_attached: is_attached (context)
		deferred
		end

	fill (context: POINTER)
		require
			context_attached: is_attached (context)
		deferred
		end

	format_stride_for_width (format, width: INTEGER): INTEGER
			-- int cairo_format_stride_for_width (cairo_format_t format, int width);
		deferred
		end

	line_to (context: POINTER; x, y: DOUBLE)
		require
			is_attached: is_attached (context)
		deferred
		end

	move_to (context: POINTER; x, y: DOUBLE)
			-- void cairo_move_to (cairo_t *cr, double x, double y);
		require
			is_attached: is_attached (context)
		deferred
		end

	new_path (context: POINTER)
		require
			is_attached: is_attached (context)
		deferred
		end

	paint (context: POINTER)
		require
			is_attached: is_attached (context)
		deferred
		end

	restore (context: POINTER)
			-- void cairo_restore (cairo_t *cr);
		require
			is_attached: is_attached (context)
		deferred
		end

	rectangle (context: POINTER; x, y, width, height: DOUBLE)
		require
			is_attached: is_attached (context)
		deferred
		end

	rotate (context: POINTER; angle: DOUBLE)
			-- void cairo_rotate (cairo_t *cr, double angle);
		require
			is_attached: is_attached (context)
		deferred
		end

	save (context: POINTER)
			-- void cairo_save (cairo_t *cr);
		require
			is_attached: is_attached (context)
		deferred
		end

	scale (context: POINTER; sx, sy: DOUBLE)
			-- void cairo_scale (cairo_t *cr, double sx, double sy);
		require
			is_attached: is_attached (context)
		deferred
		end

	select_font_face (context, family_utf8: POINTER; slant, weight: INTEGER)
			-- cairo_public void cairo_select_font_face (
			--		cairo_t *cr, const char *family, cairo_font_slant_t slant, cairo_font_weight_t weight
			-- );
		require
			is_attached: is_attached (context)
		deferred
		end

	stroke (context: POINTER)
		require
			is_attached: is_attached (context)
		deferred
		end

	surface_flush (surface: POINTER)
			-- void cairo_surface_flush (cairo_surface_t *surface);
		require
			is_attached: is_attached (surface)
		deferred
		end

	show_text (context, text_utf8: POINTER)
			-- void cairo_show_text (cairo_t *cr, const char *utf8);
		require
			is_attached: is_attached (context)
		deferred
		end

	translate (context: POINTER; tx, ty: DOUBLE)
		require
			is_attached: is_attached (context)
		deferred
		end

feature -- Memory release

	destroy (context: POINTER)
			-- void cairo_destroy (cairo_t *cr);
		require
			is_attached: is_attached (context)
		deferred
		end

	destroy_surface (surface: POINTER)
			-- void cairo_surface_destroy (cairo_surface_t *surface);
		require
			is_attached: is_attached (surface)
		deferred
		end

end
