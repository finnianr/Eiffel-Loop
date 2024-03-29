note
	description: "Unix implementation of ${CAIRO_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "14"

class
	CAIRO_API

inherit
	CAIRO_I
		rename
			default_create as make
		end

	EL_UNIX_IMPLEMENTATION
		rename
			default_create as make
		end

create
	make

feature -- Access

	frozen antialias (context: POINTER): INTEGER
			-- cairo_antialias_t cairo_get_antialias (cairo_t *cr);
		external
			"C signature (cairo_t *): EIF_INTEGER use <cairo.h>"
		alias
			"cairo_get_antialias"
		end

	frozen format_stride_for_width (format, width: INTEGER): INTEGER
			-- int cairo_format_stride_for_width (cairo_format_t format, int width);
		external
			"C signature (cairo_format_t, int): EIF_INTEGER use <cairo.h>"
		alias
			"cairo_format_stride_for_width"
		end

	frozen surface_data (surface: POINTER): POINTER
			-- unsigned char * cairo_image_surface_get_data (cairo_surface_t *surface);
		external
			"C signature (cairo_surface_t *): EIF_POINTER use <cairo.h>"
		alias
			"cairo_image_surface_get_data"
		end

	frozen surface_format (surface: POINTER): INTEGER
			-- cairo_format_t cairo_image_surface_get_format (cairo_surface_t *surface);
		external
			"C signature (cairo_surface_t *): EIF_INTEGER use <cairo.h>"
		alias
			"cairo_image_surface_get_format"
		end

	frozen surface_height (surface: POINTER): INTEGER
			-- int cairo_image_surface_get_height (cairo_surface_t *surface);
		external
			"C signature (cairo_surface_t *): EIF_INTEGER use <cairo.h>"
		alias
			"cairo_image_surface_get_height"
		end

	frozen surface_width (surface: POINTER): INTEGER
			-- int cairo_image_surface_get_width (cairo_surface_t *surface);
		external
			"C signature (cairo_surface_t *): EIF_INTEGER use <cairo.h>"
		alias
			"cairo_image_surface_get_width"
		end

	frozen version_compact: INTEGER
			-- int cairo_version ();
		external
			"C signature (): EIF_INTEGER use <cairo.h>"
		alias
			"cairo_version"
		end

feature -- Status setting

	frozen matrix_init_scale (matrix: POINTER; scale_x, scale_y: DOUBLE)
		-- Initializes matrix to a transformation that scales by `scale_x', `scale_y'
		-- in the X and Y dimensions, respectively.

		-- void cairo_matrix_init_scale (cairo_matrix_t *matrix, double sx, double sy);
		external
			"C signature (cairo_matrix_t *, double, double) use <cairo.h>"
		alias
			"cairo_matrix_init_scale"
		end

	frozen surface_finish (surface: POINTER)
			-- void cairo_surface_finish (cairo_surface_t *surface);
		external
			"C signature (cairo_surface_t *) use <cairo.h>"
		alias
			"cairo_surface_finish"
		end

	frozen reset_clip (context: POINTER)
			-- void cairo_reset_clip (cairo_t *cr);
		external
			"C signature (cairo_t *) use <cairo.h>"
		alias
			"cairo_reset_clip"
		end

	frozen surface_mark_dirty (surface: POINTER)
			-- void	cairo_surface_mark_dirty (cairo_surface_t *surface);
		external
			"C signature (cairo_surface_t *) use <cairo.h>"
		alias
			"cairo_surface_mark_dirty"
		end

feature -- Factory

	frozen new_cairo (surface: POINTER): POINTER
			-- cairo_t * cairo_create (cairo_surface_t *target);
		external
			"C signature (cairo_surface_t *): EIF_POINTER use <cairo.h>"
		alias
			"cairo_create"
		end

	frozen new_image_surface (format, width, height: INTEGER): POINTER
			-- cairo_surface_t * cairo_image_surface_create (cairo_format_t format, int width, int height);
		external
			"C signature (cairo_format_t, int, int): EIF_POINTER use <cairo.h>"
		alias
			"cairo_image_surface_create"
		end

	frozen new_image_surface_from_png (png_path: POINTER): POINTER
			-- -- cairo_surface_t * cairo_image_surface_create_from_png (const char *filename);
		external
			"C signature (const char *): EIF_POINTER use <cairo.h>"
		alias
			"cairo_image_surface_create_from_png"
		end

	frozen new_image_surface_for_data (data: POINTER; format, width, height, stride: INTEGER): POINTER
			-- cairo_surface_t * cairo_image_surface_create_for_data (
			--		unsigned char *data, cairo_format_t format, int width, int height, int stride
			-- );
		external
			"C signature (unsigned char *, cairo_format_t, int, int, int): EIF_POINTER use <cairo.h>"
		alias
			"cairo_image_surface_create_for_data"
		end

	frozen new_pattern_for_surface (surface: POINTER): POINTER
		-- cairo_pattern_t * cairo_pattern_create_for_surface (cairo_surface_t *surface);
		external
			"C signature (cairo_surface_t *): EIF_POINTER use <cairo.h>"
		alias
			"cairo_pattern_create_for_surface"
		end

feature -- Element change

	frozen set_antialias (context: POINTER; a_antialias: INTEGER)
			-- void cairo_set_antialias (cairo_t *cr, cairo_antialias_t antialias);
		external
			"C signature (cairo_t *, cairo_antialias_t) use <cairo.h>"
		alias
			"cairo_set_antialias"
		end

	frozen set_line_width (context: POINTER; size: DOUBLE)
			-- void cairo_set_line_width (cairo_t *cr, double width);
		external
			"C signature (cairo_t *, double) use <cairo.h>"
		alias
			"cairo_set_line_width"
		end

	frozen set_font_size (context: POINTER; size: DOUBLE)
			-- void cairo_set_font_size (cairo_t *cr, double size);
		external
			"C signature (cairo_t *, double) use <cairo.h>"
		alias
			"cairo_set_font_size"
		end

	frozen set_pattern_matrix (pattern, matrix: POINTER)
		-- Sets the pattern's transformation matrix to matrix
		-- void cairo_pattern_set_matrix (cairo_pattern_t *pattern, const cairo_matrix_t *matrix);
		external
			"C signature (cairo_pattern_t *, cairo_matrix_t *) use <cairo.h>"
		alias
			"cairo_pattern_set_matrix"
		end

	frozen set_pattern_filter (pattern: POINTER; filter: INTEGER)
		-- void cairo_pattern_set_filter (cairo_pattern_t *pattern, cairo_filter_t filter);
		external
			"C signature (cairo_pattern_t *, cairo_filter_t) use <cairo.h>"
		alias
			"cairo_pattern_set_filter"
		end

	frozen set_source (context, pattern: POINTER)
		-- void cairo_set_source (cairo_t *cr, cairo_pattern_t *source);
		external
			"C signature (cairo_t *, cairo_pattern_t *) use <cairo.h>"
		alias
			"cairo_set_source"
		end

	frozen set_source_rgb (context: POINTER; red, green, blue: DOUBLE)
		-- void cairo_set_source_rgb (cairo_t *cr, double red, double green, double blue);
		external
			"C signature (cairo_t *, double, double, double) use <cairo.h>"
		alias
			"cairo_set_source_rgb"
		end

	frozen set_source_rgba (context: POINTER; red, green, blue, alpha: DOUBLE)
			-- void cairo_set_source_rgba (cairo_t *cr, double red, double green, double blue);
		external
			"C signature (cairo_t *, double, double, double, double) use <cairo.h>"
		alias
			"cairo_set_source_rgba"
		end

	frozen set_source_surface (context, surface: POINTER; x, y: DOUBLE)
			-- void cairo_set_source_surface (cairo_t *cr, cairo_surface_t *surface, double x, double y);
		external
			"C signature (cairo_t *, cairo_surface_t *, double, double) use <cairo.h>"
		alias
			"cairo_set_source_surface"
		end

feature -- Basic operations

	frozen arc (context: POINTER; xc, yc, radius, angle1, angle2: DOUBLE)
			-- void cairo_arc (cairo_t *cr, double xc, double yc, double radius, double angle1, double angle2);
		external
			"C signature (cairo_t *, double, double, double, double, double) use <cairo.h>"
		alias
			"cairo_arc"
		end

	frozen clip (context: POINTER)
			-- void cairo_clip (cairo_t *cr);
		external
			"C signature (cairo_t *) use <cairo.h>"
		alias
			"cairo_clip"
		end

	frozen close_sub_path (context: POINTER)
			-- void cairo_close_path (cairo_t *cr);
		external
			"C signature (cairo_t *) use <cairo.h>"
		alias
			"cairo_close_path"
		end

	frozen define_sub_path (context: POINTER)
			-- void cairo_new_sub_path (cairo_t *cr);
		external
			"C signature (cairo_t *) use <cairo.h>"
		alias
			"cairo_new_sub_path"
		end

	frozen fill (context: POINTER)
			-- void cairo_fill (cairo_t *cr);
		external
			"C signature (cairo_t *) use <cairo.h>"
		alias
			"cairo_fill"
		end

	frozen line_to (context: POINTER; x, y: DOUBLE)
			-- void cairo_line_to (cairo_t *cr, double x, double y);
		external
			"C signature (cairo_t *, double, double) use <cairo.h>"
		alias
			"cairo_line_to"
		end

	frozen mask_surface (context, surface: POINTER; x, y: DOUBLE)
			-- void cairo_mask_surface (cairo_t *cr, cairo_surface_t *surface, double surface_x, double surface_y);
		external
			"C signature (cairo_t *, cairo_surface_t *, double, double) use <cairo.h>"
		alias
			"cairo_mask_surface"
		end

	frozen move_to (context: POINTER; x, y: DOUBLE)
			-- void cairo_move_to (cairo_t *cr, double x, double y);
		external
			"C signature (cairo_t *, double, double) use <cairo.h>"
		alias
			"cairo_move_to"
		end

	frozen new_path (context: POINTER)
			-- void cairo_new_path (cairo_t *cr);
		external
			"C signature (cairo_t *) use <cairo.h>"
		alias
			"cairo_new_path"
		end

	frozen paint (context: POINTER)
			-- void cairo_paint (cairo_t *cr);
		external
			"C signature (cairo_t *) use <cairo.h>"
		alias
			"cairo_paint"
		end

	frozen paint_with_alpha (context: POINTER; alpha: DOUBLE)
			-- void cairo_paint_with_alpha (cairo_t *cr, double alpha);
		external
			"C signature (cairo_t *, double) use <cairo.h>"
		alias
			"cairo_paint_with_alpha"
		end

	frozen rectangle (context: POINTER; x, y, width, height: DOUBLE)
			-- void cairo_rectangle (cairo_t *cr, double x, double y, double width, double height);
		external
			"C signature (cairo_t *, double, double, double, double) use <cairo.h>"
		alias
			"cairo_rectangle"
		end

	frozen restore (context: POINTER)
			-- void cairo_restore (cairo_t *cr);
		external
			"C signature (cairo_t *) use <cairo.h>"
		alias
			"cairo_restore"
		end

	frozen rotate (context: POINTER; angle: DOUBLE)
			-- void cairo_rotate (cairo_t *cr, double angle);
		external
			"C signature (cairo_t *, double) use <cairo.h>"
		alias
			"cairo_rotate"
		end

	frozen save (context: POINTER)
			-- void cairo_save (cairo_t *cr);
		external
			"C signature (cairo_t *) use <cairo.h>"
		alias
			"cairo_save"
		end

	frozen scale (context: POINTER; sx, sy: DOUBLE)
			-- void cairo_scale (cairo_t *cr, double sx, double sy);
		external
			"C signature (cairo_t *, double, double) use <cairo.h>"
		alias
			"cairo_scale"
		end

	frozen select_font_face (context, family_utf8: POINTER; slant, weight: INTEGER)
			-- cairo_public void cairo_select_font_face (
			--		cairo_t *cr, const char *family, cairo_font_slant_t slant, cairo_font_weight_t weight
			-- );
		external
			"C signature (cairo_t *, const char *, cairo_font_slant_t, cairo_font_weight_t) use <cairo.h>"
		alias
			"cairo_select_font_face"
		end

	frozen stroke (context: POINTER)
			-- void cairo_stroke (cairo_t *cr);
		external
			"C signature (cairo_t *) use <cairo.h>"
		alias
			"cairo_stroke"
		end

	frozen surface_flush (surface: POINTER)
			-- void cairo_surface_flush (cairo_surface_t *surface);
		external
			"C signature (cairo_surface_t *) use <cairo.h>"
		alias
			"cairo_surface_flush"
		end

	frozen show_text (context, text_utf8: POINTER)
			-- void cairo_show_text (cairo_t *cr, const char *utf8);
		external
			"C signature (cairo_t *, const char *) use <cairo.h>"
		alias
			"cairo_show_text"
		end

	frozen translate (context: POINTER; tx, ty: DOUBLE)
			-- void cairo_translate (cairo_t *cr, double tx, double ty);
		external
			"C signature (cairo_t *, double, double) use <cairo.h>"
		alias
			"cairo_translate"
		end

feature -- Memory release

	frozen destroy (context: POINTER)
		-- void cairo_destroy (cairo_t *cr);
		external
			"C signature (cairo_t*) use <cairo.h>"
		alias
			"cairo_destroy"
		end

	frozen destroy_pattern (pattern: POINTER)
		-- void cairo_pattern_destroy (cairo_pattern_t *pattern);
		external
			"C signature (cairo_pattern_t*) use <cairo.h>"
		alias
			"cairo_pattern_destroy"
		end

	frozen destroy_surface (surface: POINTER)
			-- void cairo_surface_destroy (cairo_surface_t *surface);
		external
			"C signature (cairo_surface_t*) use <cairo.h>"
		alias
			"cairo_surface_destroy"
		end

feature {NONE} -- MS windows

	frozen windows_surface_dc (surface: POINTER): POINTER
		-- Windows surface device context or NULL if it is not a windows surface
		-- HDC cairo_win32_surface_get_dc (cairo_surface_t *surface);
		do
			-- Not implemented on Unix
		end

	frozen new_win32_surface_create (hdc: POINTER): POINTER
		do
			-- Not implemented on Unix
		end

	frozen new_win32_surface_create_with_format (hdc: POINTER; format: INTEGER): POINTER
		do
			-- Not implemented on Unix
		end

end