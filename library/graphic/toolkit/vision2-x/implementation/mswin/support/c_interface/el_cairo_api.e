note
	description: "Summary description for {EL_CAIRO_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_CAIRO_API

inherit
	EL_DYNAMIC_MODULE

	EL_CAIRO_I
		undefine
			dispose
		end

	EL_CAIRO_C_API
		undefine
			dispose
		end

create
	make

feature -- Access

	antialias (context: POINTER): INTEGER
			-- void cairo_set_antialias (cairo_t *cr, cairo_antialias_t antialias);
		do
			Result := cairo_get_antialias (pointer_antialias, context)
		end

	surface_data (surface: POINTER): POINTER
			-- unsigned char * cairo_image_surface_get_data (cairo_surface_t *surface);
		do
			Result := cairo_image_surface_get_data (pointer_surface_data, surface)
		end

	surface_format (surface: POINTER): INTEGER
			-- cairo_format_t cairo_image_surface_get_format (cairo_surface_t *surface);
		do
			Result := cairo_image_surface_get_format (pointer_surface_format, surface)
		end

	surface_height (surface: POINTER): INTEGER
		do
			Result := cairo_image_surface_get_height (pointer_surface_height, surface)
		end

	surface_width (surface: POINTER): INTEGER
		do
			Result := cairo_image_surface_get_width (pointer_surface_width, surface)
		end

feature -- Factory

	new_cairo (surface_ptr: POINTER): POINTER
			-- cairo_t * cairo_create (cairo_surface_t *target);
		do
			Result := cairo_create (pointer_create, surface_ptr)
		end

	new_image_surface (format, width, height: INTEGER): POINTER
		do
			Result := cairo_image_surface_create (pointer_new_image_surface, format, width, height)
		end

	new_image_surface_from_png (png_path: POINTER): POINTER
		do
			Result := cairo_image_surface_create_from_png (pointer_new_image_surface_from_png, png_path)
		end

	new_image_surface_for_data (data: POINTER; format, width, height, stride: INTEGER): POINTER
			-- cairo_surface_t * cairo_image_surface_create_for_data (
			--		unsigned char *data, cairo_format_t format, int width, int height, int stride
			-- );
		do
			Result := cairo_image_surface_create_for_data (
				pointer_image_surface_create_for_data, data, format, width, height, stride
			)
		end

	new_win32_surface_create (hdc: POINTER): POINTER
		do
			Result := cairo_win32_surface_create (pointer_new_win32_surface_create, hdc)
		end

feature -- Status setting

	surface_mark_dirty (surface: POINTER)
			-- void	cairo_surface_mark_dirty (cairo_surface_t *surface);
		do
			cairo_surface_mark_dirty (pointer_surface_mark_dirty, surface)
		end

	reset_clip (context: POINTER)
		do
			cairo_reset_clip (pointer_reset_clip, context)
		end

feature -- Element change

	set_antialias (context: POINTER; a_antialias: INTEGER)
			-- void cairo_set_antialias (cairo_t *cr, cairo_antialias_t antialias);
		do
			cairo_set_antialias (pointer_set_antialias, context, a_antialias)
		end

	set_font_size (context: POINTER; size: DOUBLE)
			-- void cairo_set_font_size (cairo_t *cr, double size);
		do
			cairo_set_font_size (pointer_set_font_size, context, size)
		end

	set_line_width (context: POINTER; size: DOUBLE)
			-- void cairo_set_line_width (cairo_t *cr, double width);
		do
			cairo_set_line_width (pointer_set_line_width, context, size)
		end

	set_source_rgb (context: POINTER; red, green, blue: DOUBLE)
			-- void cairo_set_source_rgb (cairo_t *cr, double red, double green, double blue);
		do
			cairo_set_source_rgb (pointer_set_source_rgb, context, red, green, blue)
		end

	set_source_rgba (context: POINTER; red, green, blue, alpha: DOUBLE)
			-- void cairo_set_source_rgb (cairo_t *cr, double red, double green, double blue);
		do
			cairo_set_source_rgba (pointer_set_source_rgba, context, red, green, blue, alpha)
		end

	set_source_surface (context, surface: POINTER; x, y: DOUBLE)
		do
			cairo_set_source_surface (pointer_set_source_surface, context, surface, x, y)
		end

feature -- Status change

	format_stride_for_width (format, width: INTEGER): INTEGER
			-- int cairo_format_stride_for_width (cairo_format_t format, int width);
		do
			Result := cairo_format_stride_for_width (pointer_format_stride_for_width, format, width)
		end

feature -- Basic operations

	arc (context: POINTER; xc, yc, radius, angle1, angle2: DOUBLE)
		do
			cairo_arc (pointer_arc, context, xc, yc, radius, angle1, angle2)
		end

	clip (context: POINTER)
		do
			cairo_clip (pointer_clip, context)
		end

	close_sub_path (context: POINTER)
		do
			cairo_close_path (pointer_close_sub_path, context)
		end

	define_sub_path (context: POINTER)
		do
			cairo_new_sub_path (pointer_define_sub_path, context)
		end

	fill (context: POINTER)
		do
			cairo_fill (pointer_fill, context)
		end

	line_to (context: POINTER; x, y: DOUBLE)
		do
			cairo_line_to (pointer_line_to, context, x, y)
		end

	move_to (context: POINTER; x, y: DOUBLE)
			-- void cairo_move_to (cairo_t *cr, double x, double y);
		do
			cairo_move_to (pointer_move_to, context, x, y)
		end

	new_path (context: POINTER)
		do
			cairo_new_path (pointer_new_path, context)
		end

	paint (context: POINTER)
		do
			cairo_paint (pointer_paint, context)
		end

	rectangle (context: POINTER; x, y, width, height: DOUBLE)
			-- void cairo_rectangle (cairo_t *cr, double x, double y, double width, double height);
		do
			cairo_rectangle (pointer_rectangle, context, x, y, width, height)
		end

	restore (context: POINTER)
			-- void cairo_restore (cairo_t *cr);
		do
			cairo_restore (pointer_restore, context)
		end

	rotate (context: POINTER; angle: DOUBLE)
			-- void cairo_rotate (cairo_t *cr, double angle);
		do
			cairo_rotate (pointer_rotate, context, angle)
		end

	save (context: POINTER)
			-- void cairo_save (cairo_t *cr);
		do
			cairo_save (pointer_save, context)
		end

	scale (context: POINTER; sx, sy: DOUBLE)
			-- void cairo_scale (cairo_t *cr, double sx, double sy);
		do
			cairo_scale (pointer_scale, context, sx, sy)
		end

	select_font_face (context, family_utf8: POINTER; slant, weight: INTEGER)
			-- cairo_public void cairo_select_font_face (
			--		cairo_t *cr, const char *family, cairo_font_slant_t slant, cairo_font_weight_t weight
			-- );
		do
			cairo_select_font_face (pointer_select_font_face, context, family_utf8, slant, weight)
		end

	stroke (context: POINTER)
			-- void cairo_stroke (cairo_t *cr);
		do
			cairo_stroke (pointer_stroke, context)
		end

	surface_flush (surface_ptr: POINTER)
			-- void cairo_surface_flush (cairo_surface_t *surface);
		do
			cairo_surface_flush (pointer_surface_flush, surface_ptr)
		end

	show_text (context, text_utf8: POINTER)
			-- void cairo_show_text (cairo_t *cr, const char *utf8);
		do
			cairo_show_text (pointer_show_text, context, text_utf8)
		end

	translate (context: POINTER; tx, ty: DOUBLE)
			-- void cairo_translate (cairo_t *cr, double tx, double ty);
		do
			cairo_translate (pointer_translate, context, tx, ty)
		end

feature -- C memory release

	destroy (context: POINTER)
			-- void cairo_destroy (cairo_t *cr);
		do
			cairo_destroy (pointer_destroy, context)
		end

	destroy_surface (surface_ptr: POINTER)
			-- void cairo_surface_destroy (cairo_surface_t *surface);
		do
			cairo_surface_destroy (pointer_destroy_surface, surface_ptr)
		end

feature {NONE} -- Implementation

	assign_pointers
		do
			pointer_create := 								function_pointer ("create")
			pointer_new_image_surface :=					function_pointer ("image_surface_create")
			pointer_new_image_surface_from_png :=		function_pointer ("image_surface_create_from_png")
			pointer_image_surface_create_for_data := 	function_pointer ("image_surface_create_for_data")
			pointer_new_win32_surface_create := 		function_pointer ("win32_surface_create")

			pointer_antialias :=								function_pointer ("get_antialias")
			pointer_surface_data := 						function_pointer ("image_surface_get_data")
			pointer_surface_format := 						function_pointer ("image_surface_get_format")
			pointer_surface_height :=  					function_pointer ("image_surface_get_height")
			pointer_surface_width :=  						function_pointer ("image_surface_get_width")

			pointer_surface_mark_dirty :=					function_pointer ("surface_mark_dirty")
			pointer_reset_clip :=							function_pointer ("reset_clip")

			pointer_set_antialias :=						function_pointer ("set_antialias")
			pointer_set_font_size := 						function_pointer ("set_font_size")
			pointer_set_line_width :=						function_pointer ("set_line_width")
			pointer_set_source_rgb := 						function_pointer ("set_source_rgb")
			pointer_set_source_rgba := 					function_pointer ("set_source_rgba")
			pointer_set_source_surface := 				function_pointer ("set_source_surface")


			pointer_arc := 									function_pointer ("arc")
			pointer_clip := 									function_pointer ("clip")
			pointer_close_sub_path :=						function_pointer ("close_path")
			pointer_define_sub_path := 					function_pointer ("new_sub_path")
			pointer_select_font_face :=					function_pointer ("select_font_face")
			pointer_fill := 									function_pointer ("fill")
			pointer_format_stride_for_width := 			function_pointer ("format_stride_for_width")
			pointer_line_to := 								function_pointer ("line_to")
			pointer_move_to := 								function_pointer ("move_to")
			pointer_new_path := 								function_pointer ("new_path")
			pointer_paint :=									function_pointer ("paint")
			pointer_rectangle := 							function_pointer ("rectangle")
			pointer_restore := 								function_pointer ("restore")
			pointer_rotate := 								function_pointer ("rotate")
			pointer_save := 									function_pointer ("save")
			pointer_scale := 									function_pointer ("scale")
			pointer_surface_flush := 						function_pointer ("surface_flush")
			pointer_show_text := 							function_pointer ("show_text")
			pointer_stroke :=									function_pointer ("stroke")
			pointer_translate :=								function_pointer ("translate")

			pointer_destroy := 								function_pointer ("destroy")
			pointer_destroy_surface :=						function_pointer ("surface_destroy")
		end

feature {NONE} -- Implementation: attributes

	pointer_antialias: POINTER

	pointer_arc: POINTER

	pointer_clip: POINTER

	pointer_close_sub_path: POINTER

	pointer_define_sub_path: POINTER

	pointer_create: POINTER

	pointer_destroy: POINTER

	pointer_destroy_surface: POINTER

	pointer_fill: POINTER

	pointer_format_stride_for_width: POINTER

	pointer_image_surface_create_for_data: POINTER

	pointer_line_to: POINTER

	pointer_move_to: POINTER

	pointer_new_image_surface: POINTER

	pointer_new_image_surface_from_png: POINTER

	pointer_new_path: POINTER

	pointer_new_win32_surface_create: POINTER

	pointer_paint: POINTER

	pointer_rectangle: POINTER

	pointer_reset_clip: POINTER

	pointer_restore: POINTER

	pointer_rotate: POINTER

	pointer_save: POINTER

	pointer_scale: POINTER

	pointer_select_font_face: POINTER

	pointer_set_antialias: POINTER

	pointer_set_font_size: POINTER

	pointer_set_line_width: POINTER

	pointer_set_source_rgb: POINTER

	pointer_set_source_rgba: POINTER

	pointer_set_source_surface : POINTER

	pointer_show_text: POINTER

	pointer_stroke: POINTER

	pointer_surface_data: POINTER

	pointer_surface_flush: POINTER

	pointer_surface_format: POINTER

	pointer_surface_height: POINTER

	pointer_surface_mark_dirty: POINTER

	pointer_surface_width: POINTER

	pointer_translate: POINTER

feature {NONE} -- Constants

	Module_name: STRING = "libcairo-2"

	Name_prefix: STRING = "cairo_"

end
