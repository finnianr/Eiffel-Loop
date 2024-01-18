note
	description: "Windows implementation of ${CAIRO_I}"
	notes: "Using Cairo version 1.12.16 from package gtk+-bundle_3.10.4-20131202_win64.zip"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:18:15 GMT (Sunday 5th November 2023)"
	revision: "13"

class
	CAIRO_API

inherit
	EL_DYNAMIC_MODULE [CAIRO_API_POINTERS]

	CAIRO_I

	CAIRO_C_API

	EL_WINDOWS_IMPLEMENTATION

create
	make

feature -- Access

	antialias (context: POINTER): INTEGER
			-- void cairo_set_antialias (cairo_t *cr, cairo_antialias_t antialias);
		do
			Result := cairo_get_antialias (api.get_antialias, context)
		end

	surface_data (surface: POINTER): POINTER
			-- unsigned char * cairo_image_surface_get_data (cairo_surface_t *surface);
		do
			Result := cairo_image_surface_get_data (api.image_surface_get_data, surface)
		end

	surface_format (surface: POINTER): INTEGER
			-- cairo_format_t cairo_image_surface_get_format (cairo_surface_t *surface);
		do
			Result := cairo_image_surface_get_format (api.image_surface_get_format, surface)
		end

	surface_height (surface: POINTER): INTEGER
		do
			Result := cairo_image_surface_get_height (api.image_surface_get_height, surface)
		end

	surface_width (surface: POINTER): INTEGER
		do
			Result := cairo_image_surface_get_width (api.image_surface_get_width, surface)
		end

	version_compact: INTEGER
		do
			Result := cairo_version (api.version)
		end

	windows_surface_dc (surface: POINTER): POINTER
		-- Windows surface device context or NULL if it is not a windows surface
		-- HDC cairo_win32_surface_get_dc (cairo_surface_t *surface);
		do
			Result := cairo_win32_surface_get_dc (api.win32_surface_get_dc, surface)
		end

feature -- Factory

	new_cairo (surface_ptr: POINTER): POINTER
			-- cairo_t * cairo_create (cairo_surface_t *target);
		do
			Result := cairo_create (api.create_, surface_ptr)
		end

	new_image_surface (format, width, height: INTEGER): POINTER
		do
			Result := cairo_image_surface_create (api.image_surface_create, format, width, height)
		end

	new_image_surface_from_png (png_path: POINTER): POINTER
		do
			Result := cairo_image_surface_create_from_png (api.image_surface_create_from_png, png_path)
		end

	new_image_surface_for_data (data: POINTER; format, width, height, stride: INTEGER): POINTER
			-- cairo_surface_t * cairo_image_surface_create_for_data (
			--		unsigned char *data, cairo_format_t format, int width, int height, int stride
			-- );
		do
			Result := cairo_image_surface_create_for_data (
				api.image_surface_create_for_data, data, format, width, height, stride
			)
		end

	new_path (context: POINTER)
		do
			cairo_new_path (api.new_path, context)
		end

	new_pattern_for_surface (surface: POINTER): POINTER
		do
			Result := cairo_pattern_create_for_surface (api.pattern_create_for_surface, surface)
		end

	new_win32_surface_create (hdc: POINTER): POINTER
		do
			Result := cairo_win32_surface_create (api.win32_surface_create, hdc)
		end

	new_win32_surface_create_with_format (hdc: POINTER; format: INTEGER): POINTER
		do
--			Not available in version 1.12.16 of Cairo for Windows
--			Result := cairo_win32_surface_create_with_format (api.win32_surface_create_with_format, hdc, format)
		end

feature -- Status setting

	matrix_init_scale (matrix: POINTER; scale_x, scale_y: DOUBLE)
		-- Initializes matrix to a transformation that scales by `scale_x', `scale_y'
		-- in the X and Y dimensions, respectively.
		do
			cairo_matrix_init_scale (api.matrix_init_scale, matrix, scale_x, scale_y)
		end

	surface_finish (surface: POINTER)
		do
			cairo_surface_finish (api.surface_finish, surface)
		end

	surface_mark_dirty (surface: POINTER)
			-- void	cairo_surface_mark_dirty (cairo_surface_t *surface);
		do
			cairo_surface_mark_dirty (api.surface_mark_dirty, surface)
		end

	reset_clip (context: POINTER)
		do
			cairo_reset_clip (api.reset_clip, context)
		end

feature -- Element change

	select_font_face (context, family_utf8: POINTER; slant, weight: INTEGER)
			-- cairo_public void cairo_select_font_face (
			--		cairo_t *cr, const char *family, cairo_font_slant_t slant, cairo_font_weight_t weight
			-- );
		do
			cairo_select_font_face (api.select_font_face, context, family_utf8, slant, weight)
		end

	set_antialias (context: POINTER; a_antialias: INTEGER)
			-- void cairo_set_antialias (cairo_t *cr, cairo_antialias_t antialias);
		do
			cairo_set_antialias (api.set_antialias, context, a_antialias)
		end

	set_font_size (context: POINTER; size: DOUBLE)
			-- void cairo_set_font_size (cairo_t *cr, double size);
		do
			cairo_set_font_size (api.set_font_size, context, size)
		end

	set_line_width (context: POINTER; size: DOUBLE)
			-- void cairo_set_line_width (cairo_t *cr, double width);
		do
			cairo_set_line_width (api.set_line_width, context, size)
		end

	set_pattern_filter (pattern: POINTER; filter: INTEGER)
		-- void cairo_pattern_set_filter (cairo_pattern_t *pattern, cairo_filter_t filter);
		do
			cairo_pattern_set_filter (api.pattern_set_filter, pattern, filter)
		end

	set_pattern_matrix (pattern, matrix: POINTER)
		-- Sets the pattern's transformation matrix to matrix
		-- void cairo_pattern_set_matrix (cairo_pattern_t *pattern, const cairo_matrix_t *matrix);
		do
			cairo_pattern_set_matrix (api.pattern_set_matrix, pattern, matrix)
		end

	set_source_rgb (context: POINTER; red, green, blue: DOUBLE)
			-- void cairo_set_source_rgb (cairo_t *cr, double red, double green, double blue);
		do
			cairo_set_source_rgb (api.set_source_rgb, context, red, green, blue)
		end

	set_source (context, pattern: POINTER)
			-- void cairo_set_source (cairo_t *cr, cairo_pattern_t *source);
		do
			cairo_set_source (api.set_source, context, pattern)
		end

	set_source_rgba (context: POINTER; red, green, blue, alpha: DOUBLE)
			-- void cairo_set_source_rgb (cairo_t *cr, double red, double green, double blue);
		do
			cairo_set_source_rgba (api.set_source_rgba, context, red, green, blue, alpha)
		end

	set_source_surface (context, surface: POINTER; x, y: DOUBLE)
		do
			cairo_set_source_surface (api.set_source_surface, context, surface, x, y)
		end

feature -- Status change

	format_stride_for_width (format, width: INTEGER): INTEGER
			-- int cairo_format_stride_for_width (cairo_format_t format, int width);
		do
			Result := cairo_format_stride_for_width (api.format_stride_for_width, format, width)
		end

feature -- Transformations

	rotate (context: POINTER; angle: DOUBLE)
			-- void cairo_rotate (cairo_t *cr, double angle);
		do
			cairo_rotate (api.rotate, context, angle)
		end

	scale (context: POINTER; sx, sy: DOUBLE)
			-- void cairo_scale (cairo_t *cr, double sx, double sy);
		do
			cairo_scale (api.scale, context, sx, sy)
		end

	translate (context: POINTER; tx, ty: DOUBLE)
			-- void cairo_translate (cairo_t *cr, double tx, double ty);
		do
			cairo_translate (api.translate, context, tx, ty)
		end

feature -- Basic operations

	arc (context: POINTER; xc, yc, radius, angle1, angle2: DOUBLE)
		do
			cairo_arc (api.arc, context, xc, yc, radius, angle1, angle2)
		end

	clip (context: POINTER)
		do
			cairo_clip (api.clip, context)
		end

	close_sub_path (context: POINTER)
		do
			cairo_close_path (api.close_path, context)
		end

	define_sub_path (context: POINTER)
		do
			cairo_new_sub_path (api.new_sub_path, context)
		end

	fill (context: POINTER)
		do
			cairo_fill (api.fill, context)
		end

	line_to (context: POINTER; x, y: DOUBLE)
		do
			cairo_line_to (api.line_to, context, x, y)
		end

	mask_surface (context, surface: POINTER; x, y: DOUBLE)
		do
			cairo_mask_surface (api.mask_surface, context, surface, x, y)
		end

	move_to (context: POINTER; x, y: DOUBLE)
			-- void cairo_move_to (cairo_t *cr, double x, double y);
		do
			cairo_move_to (api.move_to, context, x, y)
		end

	paint (context: POINTER)
		do
			cairo_paint (api.paint, context)
		end

	paint_with_alpha (context: POINTER; alpha: DOUBLE)
		do
			cairo_paint_with_alpha (api.paint_with_alpha, context, alpha)
		end

	rectangle (context: POINTER; x, y, width, height: DOUBLE)
			-- void cairo_rectangle (cairo_t *cr, double x, double y, double width, double height);
		do
			cairo_rectangle (api.rectangle, context, x, y, width, height)
		end

	restore (context: POINTER)
			-- void cairo_restore (cairo_t *cr);
		do
			cairo_restore (api.restore, context)
		end

	save (context: POINTER)
			-- void cairo_save (cairo_t *cr);
		do
			cairo_save (api.save, context)
		end

	stroke (context: POINTER)
			-- void cairo_stroke (cairo_t *cr);
		do
			cairo_stroke (api.stroke, context)
		end

	surface_flush (surface_ptr: POINTER)
			-- void cairo_surface_flush (cairo_surface_t *surface);
		do
			cairo_surface_flush (api.surface_flush, surface_ptr)
		end

	show_text (context, text_utf8: POINTER)
			-- void cairo_show_text (cairo_t *cr, const char *utf8);
		do
			cairo_show_text (api.show_text, context, text_utf8)
		end

feature -- C memory release

	destroy (context: POINTER)
			-- void cairo_destroy (cairo_t *cr);
		do
			cairo_destroy (api.destroy, context)
		end

	destroy_pattern (pattern: POINTER)
		do
			cairo_pattern_destroy (api.pattern_destroy, pattern)
		end

	destroy_surface (surface_ptr: POINTER)
			-- void cairo_surface_destroy (cairo_surface_t *surface);
		do
			cairo_surface_destroy (api.surface_destroy, surface_ptr)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libcairo-2"

	Name_prefix: STRING = "cairo_"

end