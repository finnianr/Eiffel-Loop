note
	description: "Summary description for {EL_DRAWABLE_PIXEL_BUFFER_IMP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_DRAWABLE_PIXEL_BUFFER_IMP

inherit
	EV_PIXEL_BUFFER_IMP
		rename
			draw_text as buffer_draw_text,
			draw_pixel_buffer as old_draw_pixel_buffer,
			make_with_pixmap as make_pixel_buffer,
			make_with_size as make_pixel_buffer_with_size,
			set_with_named_path as set_pixel_buffer_with_named_path,
			width as buffer_width,
			height as buffer_height
		undefine
			lock, unlock, default_create
		redefine
			make, make_pixel_buffer_with_size, interface, old_make, dispose
		end

	EL_DRAWABLE_PIXEL_BUFFER_I
		redefine
			interface, dispose, update_cairo_color, set_surface_color_order
		select
			make_with_pixmap
		end

	EL_SHARED_IMAGE_UTILS_API
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

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
				set_color (0)
				fill_rectangle (0, 0, a_width, a_height)
				unlock
			else
				create internal_pixmap.make_with_size (a_width, a_height)
			end
		end

	make
		do
			default_create
			Precursor
		end

	old_make (an_interface: EL_DRAWABLE_PIXEL_BUFFER)
			-- Creation method.
		do
			assign_interface (an_interface)
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_DRAWABLE_PIXEL_BUFFER note option: stable attribute end;

feature {NONE} -- Implementation

	update_cairo_color (a_cairo_ctx: POINTER)
		do
			-- Red and blue are intentionally swapped as a workaround to a bug
			Cairo.set_source_rgba (a_cairo_ctx, color.blue, color.green, color.red, 1.0)
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

	dispose
		do
			Precursor {EL_DRAWABLE_PIXEL_BUFFER_I}
			Precursor {EV_PIXEL_BUFFER_IMP}
		end

end
