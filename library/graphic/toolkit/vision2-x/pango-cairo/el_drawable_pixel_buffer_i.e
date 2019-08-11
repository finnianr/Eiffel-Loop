note
	description: "Drawable pixel buffer i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-11 10:40:04 GMT (Sunday 11th August 2019)"
	revision: "14"

deferred class
	EL_DRAWABLE_PIXEL_BUFFER_I

inherit
	EV_PIXEL_BUFFER_I
		rename
			draw_text as buffer_draw_text,
			draw_pixel_buffer as draw_pixel_buffer_at_rectangle,
			make_with_size as make_pixel_buffer_with_size,
			set_with_named_path as set_pixel_buffer_with_named_path
		redefine
			lock, unlock, interface, default_create
		end

	EV_FONTABLE_I
		undefine
			default_create
		redefine
			interface
		end

	EL_DISPOSEABLE
		undefine
			default_create
		redefine
			dispose
		end

	EL_CAIRO_CONSTANTS
		undefine
			default_create
		end

	EL_ORIENTATION_ROUTINES
		undefine
			default_create
		end

	EL_PANGO_CAIRO_CONSTANTS
		undefine
			default_create
		end

	EL_MODEL_MATH
		undefine
			default_create
		end

	EL_MODULE_UTF

	EL_MODULE_GUI

	EL_MODULE_ZSTRING

	EL_SHARED_CAIRO_API

	EL_SHARED_ONCE_STRINGS

	EL_SHARED_PANGO_API

	EL_SHARED_PANGO_CAIRO_API

	EL_SHARED_GOBJECT_API


feature {EL_DRAWABLE_PIXEL_BUFFER} -- Initialization

	default_create
			-- Called from {EL_DRAWABLE_PIXEL_BUFFER_IMP}.make
		do
			create font; create color
			set_opaque
		end

	make_cairo (a_cairo_surface: POINTER)
		do
			cairo_surface := a_cairo_surface
			cairo_ctx := Cairo.new_cairo (a_cairo_surface)
			pango_layout := Pango_cairo.create_layout (cairo_ctx)
		end

	make_with_svg_image (svg_image: EL_SVG_IMAGE; a_background_color: EL_COLOR)
		do
			make_with_size (svg_image.width, svg_image.height)
			if not a_background_color.is_transparent then
				set_color (a_background_color)
				fill_rectangle (0, 0, width, height)
			end
			set_surface_color_order
			svg_image.render (Current)
		end

	make_pixel_buffer (a_pixmap: EV_PIXMAP)
		deferred
		end

	make_pixel_buffer_with_size (a_width, a_height: INTEGER)
		deferred
		end

	make_rgb_24_with_pixmap (a_pixmap: EV_PIXMAP)
			-- make rgb 24 bit format
		do
			make_pixel_buffer (a_pixmap)
		end

	make_rgb_24_with_size (a_width, a_height: INTEGER)
		do
			make_pixel_buffer_with_size (a_width, a_height)
		end

	make_mirrored (a_buffer: EL_DRAWABLE_PIXEL_BUFFER; axis: INTEGER)
			-- make alpha 32 bit format
		require
			valid_axis: is_valid_axis (axis)
		do
			make_with_size (a_buffer.width, a_buffer.height)
			if a_buffer.is_rgb_24_bit then
				a_buffer.lock
			end
			inspect axis
				when X_axis then
					translate (0, a_buffer.height); scale (1, -1)
				when Y_axis then
					translate (a_buffer.width, 0); scale (-1, 1)
			else end
			draw_pixel_buffer (0, 0, a_buffer.implementation)
			if a_buffer.is_rgb_24_bit then
				a_buffer.unlock
			end
		end

	make_with_pixmap (a_pixmap: EV_PIXMAP)
			-- make alpha 32 bit format
		local
			rgb_24_buffer: EL_DRAWABLE_PIXEL_BUFFER
		do
			make_with_size (a_pixmap.width, a_pixmap.height)
			create rgb_24_buffer.make_rgb_24_with_pixmap (a_pixmap)
			rgb_24_buffer.lock
			draw_pixel_buffer (0, 0, rgb_24_buffer.implementation)
			rgb_24_buffer.unlock
		end

	make_with_size (a_width, a_height: INTEGER)
		do
			make_cairo (Cairo.new_image_surface (Cairo_format_argb32, a_width, a_height))
		end

feature -- Element change

	set_angle (angle: REAL)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.rotate (cairo_ctx, angle)
		end

	set_clip_rounded_rectangle (x, y, a_width, a_height, radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from EL_ORIENTATION_CONSTANTS, eg. Top_left | Top_right
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.define_sub_path (cairo_ctx)
			if (Top_right & corners_bitmap).to_boolean then
				Cairo.arc (cairo_ctx, x + a_width - radius, y + radius, radius, radians (90).opposite, 0.0);
			else
				Cairo.line_to (cairo_ctx, x + a_width, y)
			end
			if (Top_left & corners_bitmap).to_boolean then
				Cairo.arc (cairo_ctx, x + radius, y + radius, radius, radians (180), radians (270));
			else
				Cairo.line_to (cairo_ctx, x, y)
			end
			if (Bottom_right & corners_bitmap).to_boolean then
				Cairo.arc (cairo_ctx, x + a_width - radius, y + a_height - radius, radius, 0.0, radians (90));
			else
				Cairo.line_to (cairo_ctx, x + a_width, y + a_height)
			end
			if (Bottom_left & corners_bitmap).to_boolean then
				Cairo.arc (cairo_ctx, x + radius, y + a_height - radius, radius, radians (90), radians (180));
			else
				Cairo.line_to (cairo_ctx, x, y + a_height)
			end
			Cairo.close_sub_path (cairo_ctx)
			Cairo.clip (cairo_ctx);
		end

	set_color (a_color: like color)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			color := a_color
			update_cairo_color (cairo_ctx)
		end

	set_font (a_font: like font)
		require else
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			font := a_font.twin
			check_font_availability
			set_layout_text_font (a_font)
		end

	set_line_width (size: INTEGER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.set_line_width (cairo_ctx, size)
		end

	set_opaque
		do
			opacity := 100
		end

	set_opacity (percentage: INTEGER)
		do
			opacity := percentage
		end

	set_with_named_path_as_rgb_24 (a_file_name: PATH)
		do
			dispose
			set_pixel_buffer_with_named_path (a_file_name)
		end

	set_with_path (file_path: EL_FILE_PATH)
		local
			cairo_file: EL_PNG_IMAGE_FILE; l_cairo_surface: POINTER
		do
			create cairo_file.make_open_read (file_path)
			l_cairo_surface := cairo_file.read_cairo_surface
			cairo_file.close
			if l_cairo_surface /= default_pointer then
				dispose
				make_cairo (l_cairo_surface)
				set_surface_color_order
			end
		end

feature -- Basic operations

	draw_line (x1, y1, x2, y2: INTEGER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		local
			l_antialias: INTEGER
		do
			Cairo.move_to (cairo_ctx, x1, y1)
			if rotation_angle = rotation_angle.zero then
				l_antialias := Cairo.antialias (cairo_ctx)
				Cairo.set_antialias (cairo_ctx, Cairo_antialias_none)
			end
			Cairo.line_to (cairo_ctx, x2, y2)
			Cairo.stroke (cairo_ctx)
			if rotation_angle = rotation_angle.zero then
				Cairo.set_antialias (cairo_ctx, l_antialias)
			end
		end

	draw_pixel_buffer (x, y: INTEGER; a_buffer: EL_DRAWABLE_PIXEL_BUFFER_I)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.set_source_surface (cairo_ctx, a_buffer.cairo_surface, x, y)
			Cairo.set_antialias (cairo_ctx, Cairo_antialias_best)
			if opacity = 100 then
				Cairo.paint (cairo_ctx)
			elseif opacity > 0 then
				Cairo.paint_with_alpha (cairo_ctx, opacity / 100)
			end
			set_color (color) -- Need to restore color after set_source_surface
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		local
			rgb_24_buffer: EL_DRAWABLE_PIXEL_BUFFER
		do
			create rgb_24_buffer.make_rgb_24_with_pixmap (a_pixmap)
			rgb_24_buffer.lock
			draw_pixel_buffer (x, y, rgb_24_buffer.implementation)
			rgb_24_buffer.unlock
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		local
			l_antialias: INTEGER
		do
			Cairo.rectangle (cairo_ctx, x + 1, y + 1, a_width, a_height)
			if rotation_angle = rotation_angle.zero then
				l_antialias := Cairo.antialias (cairo_ctx)
				Cairo.set_antialias (cairo_ctx, Cairo_antialias_none)
			end
			Cairo.stroke (cairo_ctx)
			if rotation_angle = rotation_angle.zero then
				Cairo.set_antialias (cairo_ctx, l_antialias)
			end
		end

	draw_rotated_text_top_left (x, y: INTEGER; angle: DOUBLE; a_text: READABLE_STRING_GENERAL)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		local
			text_rect: EL_RECTANGLE; text_pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER
			l_x, l_y, hyphen_width: INTEGER
		do
			create text_rect.make_for_text (a_text, font)
			create text_pixel_buffer.make_with_size (text_rect.width, text_rect.height)

			text_pixel_buffer.set_color (color.twin)
			text_pixel_buffer.set_antialias_best
			text_pixel_buffer.set_font (font)
			text_pixel_buffer.draw_text_top_left (0, 0, a_text)

			-- Make last hyphen more prominent
			if a_text [a_text.count] = '-' then
				l_x := font.string_width (a_text.substring (1, a_text.count - 1))
				l_y := font.ascent - font.descent + 1
				hyphen_width := font.string_width (once "-") - 1
				text_pixel_buffer.set_line_width (1)
				text_pixel_buffer.draw_line (l_x + 1, l_y, l_x + hyphen_width, l_y)
			end

			save
			translate (x, y); rotate (angle)
			draw_pixel_buffer (0, 0, text_pixel_buffer.implementation)
			restore
		end

	draw_scaled_pixel_buffer (x, y, a_size, dimension: INTEGER; a_buffer: EL_DRAWABLE_PIXEL_BUFFER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit and a_buffer.locked_for_rgb_24_bit
			valid_dimension: is_valid_dimension (dimension)
		local
			scale_factor: DOUBLE
		do
			save
			inspect dimension
				when By_width then
					scale_factor := a_size / a_buffer.width
				when By_height then
					scale_factor := a_size / a_buffer.height
			else end
			scale (scale_factor, scale_factor)
			draw_pixel_buffer (x, y, a_buffer.implementation)
			restore
		end

	draw_scaled_pixmap (x, y, a_size, dimension: INTEGER; a_pixmap: EV_PIXMAP)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		local
			rgb_24_buffer: EL_DRAWABLE_PIXEL_BUFFER
		do
			create rgb_24_buffer.make_rgb_24_with_pixmap (a_pixmap)
			rgb_24_buffer.lock
			draw_scaled_pixel_buffer (x, y, a_size, dimension, rgb_24_buffer)
			rgb_24_buffer.unlock
		end

	draw_text (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			draw_text_top_left (x, y - font.ascent, a_text)
		end

	draw_text_top_left (x, y: INTEGER; a_text: READABLE_STRING_GENERAL)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		local
			actual_width, required_width: INTEGER
			l_text: READABLE_STRING_GENERAL
		do
			set_antialias_best
			Cairo.move_to (cairo_ctx, x, y)
			l_text := Zstring.to_unicode_general (a_text)
			set_layout_text (l_text)

			-- horizontal scaling to fit required width
			actual_width := layout_text_width; required_width := font.string_width (l_text)

--			Commented out these lines to fix badly aligned shadow text on button (5/9/2014)

			draw_layout_text
		end

	fill_concave_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from `EL_ORIENTATION_CONSTANTS', eg. Top_left | Top_right
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		local
			x, y, corner, i: INTEGER
		do
			from i := 1 until i > 4 loop
				corner := All_corners [i]
				if (corner & corners_bitmap).to_boolean then
					inspect corner
						when Top_left then
							x := 0; y := 0
						when Top_right then
							x := width - radius; y := 0
						when Bottom_right then
							x := width - radius; y := height - radius
						when Bottom_left then
							x := 0; y := height - radius
					else end
					set_clip_concave_corner (x, y, radius, corner)
					fill_rectangle (x, y, radius, radius)
					remove_clip
				end
				i := i + 1
			end
		end

	fill_convex_corners (radius, corners_bitmap: INTEGER)
		-- `corners_bitmap' are OR'd corner values from `EL_ORIENTATION_CONSTANTS', eg. Top_left | Top_right
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		local
			x, y, corner, i: INTEGER
		do
			from i := 1 until i > 4 loop
				corner := All_corners [i]
				if (corner & corners_bitmap).to_boolean then
					inspect corner
						when Top_left then
							x := 0; y := 0
						when Top_right then
							x := width; y := 0
						when Bottom_right then
							x := width; y := height
						when Bottom_left then
							x := 0; y := height
					else end
					fill_convex_corner (x, y, radius, corner)
				end
				i := i + 1
			end
		end

	fill_rectangle (x, y, a_width, a_height: INTEGER)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.rectangle (cairo_ctx, x, y, a_width, a_height)
			Cairo.fill (cairo_ctx)
		end

	save_as (file_path: EL_FILE_PATH)
			-- Save as png file
		local
			file_out: EL_PNG_IMAGE_FILE
		do
			create file_out.make_open_write (file_path)
			file_out.put_image (cairo_surface)
			file_out.close
		end

feature -- Status query

	is_alpha_rgb_32_bit: BOOLEAN
		do
			Result := format = Cairo_format_argb32
		end

	is_rgb_24_bit: BOOLEAN
		do
			Result := format = Cairo_format_rgb24
		end

feature -- Transform

	rotate (angle: DOUBLE)
			-- rotate coordinate system by angle in radians
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.rotate (cairo_ctx, angle)
			rotation_angle := angle
		end

	scale (x_factor, y_factor: DOUBLE)
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.scale (cairo_ctx, x_factor, y_factor)
		end

	translate (x, y: DOUBLE)
			-- translate coordinate origin to point x, y
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.translate (cairo_ctx, x, y)
		end

feature -- Status change

	lock
		require else
			unlocked: not is_locked
		do
			make_cairo (Cairo.new_image_surface_for_data (data_ptr, Cairo_format_RGB24, width, height, stride))
			Precursor
		end

	remove_clip
		do
			Cairo.reset_clip (cairo_ctx)
		end

	restore
			-- restore last drawing setting state from state stack
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.restore (cairo_ctx)
		end

	save
			-- save current drawing setting state on to a stack
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.save (cairo_ctx)
		end

	set_antialias_best
		require
			locked_for_rgb_24_bit: locked_for_rgb_24_bit
		do
			Cairo.set_antialias (cairo_ctx, Cairo_antialias_best)
--			Cairo.set_antialias (cairo_ctx, Cairo_antialias_subpixel)
		end

	unlock
		require else
			locked: is_locked
		do
			free_cairo_context
			Precursor
		end

feature -- Conversion

	to_rgb_24_buffer: EL_DRAWABLE_PIXEL_BUFFER
		require
			unlocked_for_24_rgb_format: is_rgb_24_bit implies not is_locked
		do
			if is_rgb_24_bit then
				Result := interface
			else
				create Result.make_rgb_24_with_size (width, height)
				Result.lock
				Result.draw_pixel_buffer (0, 0, interface)
				Result.unlock
			end
		end

feature -- Contract Support

	locked_for_rgb_24_bit: BOOLEAN
		-- `False' if `format = Cairo_format_rgb24' and `not locked'
		do
			Result := is_rgb_24_bit implies is_locked
		end

feature {EL_SVG_IMAGE, EL_DRAWABLE_PIXEL_BUFFER_I} -- Access

	cairo_ctx: POINTER
		-- cairo drawing context

	cairo_surface: POINTER

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_DRAWABLE_PIXEL_BUFFER note option: stable attribute end;

feature {NONE} -- Implementation

	adjust_pango_font (required_width: INTEGER)
		local
			actual_width, adjustment, signed_adjustment, limit: INTEGER
			pango_font: EL_PANGO_FONT
		do
			actual_width := layout_text_width
			if actual_width /= required_width then
				pango_font := font
				pango_font.scale (required_width / actual_width)
				set_layout_text_font (pango_font)

				-- Finetune the font height to make actual_width = required_width
				from
					actual_width := layout_text_width
					adjustment := pango_font.height // 100; limit := adjustment // 4
				until
					actual_width = required_width or else adjustment < limit
				loop
					if actual_width < required_width then
						signed_adjustment := adjustment
					else
						signed_adjustment := adjustment.opposite
					end
					pango_font.set_height (pango_font.height + signed_adjustment)
					set_layout_text_font (pango_font)
					actual_width := layout_text_width
					adjustment := adjustment // 2
				end
			end
		end

	check_font_availability
		do
		end

	dispose
		do
			if not is_in_final_collect then
				free_cairo_context
			end
		end

	draw_layout_text
		do
			Pango_cairo.update_layout (cairo_ctx, pango_layout)
			Pango_cairo.show_layout (cairo_ctx, pango_layout)
		end

	fill_convex_corner (x, y, radius, corner: INTEGER)
		require
			valid_corner: is_valid_corner (corner)
		do
			Cairo.define_sub_path (cairo_ctx)
			Cairo.move_to (cairo_ctx, x, y)
			inspect corner
				when Top_left then
					Cairo.arc (cairo_ctx, x, y, radius, 0, radians (90))
				when Top_right then
					Cairo.arc (cairo_ctx, x, y, radius, radians (90), radians (180))
				when Bottom_right then
					Cairo.arc (cairo_ctx, x, y, radius, radians (180), radians (270))
				when Bottom_left then
					Cairo.arc (cairo_ctx, x, y, radius, radians (270), radians (360))
			else end
			Cairo.close_sub_path (cairo_ctx)
			Cairo.fill (cairo_ctx);
		end

	format: INTEGER
		do
			if is_attached (cairo_surface) then
				Result := Cairo.surface_format (cairo_surface)
			else
				Result := Cairo_format_rgb24
			end
		end

	free_cairo_context
		do
			if is_attached (cairo_ctx) then
				Gobject.object_unref (pango_layout); pango_layout := default_pointer
				Cairo.destroy (cairo_ctx); cairo_ctx := default_pointer
				Cairo.destroy_surface (cairo_surface); cairo_surface := default_pointer
			end
		end

	layout_text_height: INTEGER
		do
			Result := Pango.layout_size (pango_layout).height
		end

	layout_text_width: INTEGER
		do
			Result := Pango.layout_size (pango_layout).width
		end

	set_clip_concave_corner (x, y, radius, corner: INTEGER)
		require
			valid_corner: is_valid_corner (corner)
		do
			Cairo.define_sub_path (cairo_ctx)
			inspect corner
				when Top_left then
					Cairo.move_to (cairo_ctx, x, y)
					Cairo.arc (cairo_ctx, x + radius, y + radius, radius, radians (180), radians (270))
				when Top_right then
					Cairo.move_to (cairo_ctx, x + radius, y)
					Cairo.arc (cairo_ctx, x, y + radius, radius, radians (90).opposite, 0.0)
				when Bottom_right then
					Cairo.move_to (cairo_ctx, x + radius, y + radius)
					Cairo.arc (cairo_ctx, x, y, radius, 0.0, radians (90))
				when Bottom_left then
					Cairo.move_to (cairo_ctx, x, y + radius)
					Cairo.arc (cairo_ctx, x + radius, y, radius, radians (90), radians (180))
			else end
			Cairo.close_sub_path (cairo_ctx)
			Cairo.clip (cairo_ctx);
		end

	set_layout_text (a_text: READABLE_STRING_GENERAL)
		local
			utf8_text: STRING; l_text: READABLE_STRING_GENERAL
		do
			l_text := Zstring.to_unicode_general (a_text)
			utf8_text := empty_once_string_8
			UTF.utf_32_string_into_utf_8_string_8 (l_text, utf8_text)
			Pango.set_layout_text (pango_layout, utf8_text.area.base_address, utf8_text.count)
			adjust_pango_font (font.string_width (l_text))
		end

	set_layout_text_font (a_font: EL_PANGO_FONT)
		do
			Pango.set_layout_font_description (pango_layout, a_font.item)
		end

	set_surface_color_order
			-- set color channel order (needed for Unix)
		do
		end

	update_cairo_color (a_cairo_ctx: POINTER)
		do
			Cairo.set_source_rgba (a_cairo_ctx, color.red, color.green, color.blue, 1.0)
		end

feature {NONE} -- Deferred implementation

	data_ptr: POINTER
		deferred
		end

	stride: INTEGER
		deferred
		end

feature {NONE} -- Internal attributes

	color: EV_COLOR

	font: EV_FONT

	opacity: INTEGER
		-- percentage opacity. 100 is totally opaque

	pango_layout: POINTER

	rotation_angle: DOUBLE

end
