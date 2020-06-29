note
	description: "Drawable pixel buffer imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-29 13:06:12 GMT (Monday 29th June 2020)"
	revision: "9"

class
	EL_DRAWABLE_PIXEL_BUFFER_IMP

inherit
	EV_PIXEL_BUFFER_IMP
		rename
			draw_text as buffer_draw_text,
			draw_pixel_buffer as draw_pixel_buffer_at_rectangle,
			make_with_pixmap as make_pixel_buffer,
			make_with_size as make_pixel_buffer_with_size,
			set_with_named_path as set_pixel_buffer_with_named_path
		undefine
			lock, unlock, default_create
		redefine
			make, make_pixel_buffer_with_size, interface, old_make, dispose, width, height
		end

	EL_DRAWABLE_PIXEL_BUFFER_I
		redefine
			interface, dispose, update_cairo_color, set_surface_color_order
		select
			make_with_pixmap
		end

	EL_MODULE_COLOR
		rename
			Color as Mod_color
		end

	EL_SHARED_IMAGE_UTILS_API

create
	make

feature {NONE} -- Initialization

	make
		do
			default_create
			Precursor
		end

	make_pixel_buffer_with_size (a_width, a_height: INTEGER)
			-- Create with size.
		local
			l_width, l_height: NATURAL_32
		do
			if {GTK}.gtk_maj_ver >= 2 then
				l_width := a_width.as_natural_32
				l_height := a_height.as_natural_32
				set_gdkpixbuf ({GTK}.gdk_pixbuf_new ({GTK}.gdk_colorspace_rgb_enum, True, 8, a_width, a_height))
					-- Creating managed pointer used for inspecting RGBA data.
				create reusable_managed_pointer.share_from_pointer (default_pointer, 0)
				lock
				set_color (Mod_color.black)
				fill_rectangle (0, 0, a_width, a_height)
				unlock
			else
				create internal_pixmap.make_with_size (a_width, a_height)
			end
		end

	old_make (an_interface: EL_DRAWABLE_PIXEL_BUFFER)
			-- Creation method.
		do
			assign_interface (an_interface)
		end

feature -- Measurement

	height: INTEGER
		do
			if is_attached (cairo_surface) then
				Result := Cairo.surface_height (cairo_surface)
			else
				Result := Precursor
			end
		end

	width: INTEGER
		do
			if is_attached (cairo_surface) then
				Result := Cairo.surface_width (cairo_surface)
			else
				Result := Precursor
			end
		end

feature -- Basic operations

	save_as_jpeg (file_path: EL_FILE_PATH; quality: INTEGER)
		require else
			valid_gtk_version: {GTK}.gtk_maj_ver >= 2
		local
			jpeg: EL_JPEG_PIXMAP_IMP
		do
			if interface.is_rgb_24_bit then
				create jpeg.make (gdk_pixbuf, quality, False)
				jpeg.save_as (file_path)
			else
				interface.to_rgb_24_buffer.save_as_jpeg (file_path, quality)
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation attributes

	interface: detachable EL_DRAWABLE_PIXEL_BUFFER note option: stable attribute end;

feature {NONE} -- Implementation

	dispose
		do
			Precursor {EL_DRAWABLE_PIXEL_BUFFER_I}
			Precursor {EV_PIXEL_BUFFER_IMP}
		end

	set_surface_color_order
			-- swap red and blue color channels
		do
			Cairo.surface_flush (cairo_surface)
			Image_utils.format_argb_to_abgr (Cairo.surface_data (cairo_surface), width * height)
			Cairo.surface_mark_dirty (cairo_surface)
		end

	stride: INTEGER
		do
			Result := {GTK}.gdk_pixbuf_get_rowstride (gdk_pixbuf).to_integer_32
		end

	update_cairo_color (a_cairo_ctx: POINTER)
		do
			-- Red and blue are intentionally swapped as a workaround to a bug
			Cairo.set_source_rgba (a_cairo_ctx, color.blue, color.green, color.red, 1.0)
		end

end
