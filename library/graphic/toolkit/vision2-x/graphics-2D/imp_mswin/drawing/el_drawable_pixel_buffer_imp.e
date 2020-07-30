note
	description: "Windows implementation of [$source EL_DRAWABLE_PIXEL_BUFFER_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-29 12:04:21 GMT (Wednesday 29th July 2020)"
	revision: "15"

class
	EL_DRAWABLE_PIXEL_BUFFER_IMP

inherit
	EV_PIXEL_BUFFER_IMP
		rename
			data_ptr as pixel_data,
			draw_text as buffer_draw_text,
			draw_pixel_buffer as draw_pixel_buffer_at_rectangle,
			lock as lock_rgb_24,
			unlock as unlock_rgb_24,
			make_with_pixmap as make_rgb_24_with_pixmap,
			make_with_size as make_rgb_24_with_size,
			set_with_named_path as set_rgb_24_with_path,
			height as buffer_height,
			width as buffer_width
		undefine
			default_create
		redefine
			interface, old_make
		end

	EL_DRAWABLE_PIXEL_BUFFER_I
		undefine
			unlock_rgb_24
		redefine
			interface
		end

	EL_MODULE_SYSTEM_FONTS

create
	make

feature {NONE} -- Initialization

	old_make (an_interface: EL_DRAWABLE_PIXEL_BUFFER)
			-- Creation method.
		do
			assign_interface (an_interface)
		end

feature {EV_ANY_HANDLER} -- Access

	to_gdi_bitmap: WEL_GDIP_BITMAP
		do
			if attached {EL_CAIRO_SURFACE_IMP} cairo_context.surface as surface then
				Result := surface.new_gdi_bitmap
			end
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EL_DRAWABLE_PIXEL_BUFFER note option: stable attribute end;

feature {NONE} -- Implementation

	adjust_color_channels
		do
		end

end
