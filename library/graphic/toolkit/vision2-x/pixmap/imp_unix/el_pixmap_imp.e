note
	description: "Unix implemenation of interface [$source EL_PIXMAP_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-31 15:23:56 GMT (Friday 31st July 2020)"
	revision: "6"

class
	EL_PIXMAP_IMP

inherit
	EV_PIXMAP_IMP
		export
			{EV_ANY_HANDLER} pixbuf_from_drawable
		redefine
			interface
		end

	EL_PIXMAP_I
		undefine
			flush, save_to_named_path
		redefine
			interface
		end

create
	make

feature {NONE} -- Initialization

	make_scaled_to_size (dimension: NATURAL_8; other: EV_PIXMAP; size: INTEGER)
		local
			a_gdkpixbuf, scaled_pixbuf: POINTER
			a_scale_type: INTEGER; area: EL_RECTANGLE
		do
			create area.make_scaled_for_widget (dimension, other, size)

			if attached {EV_PIXMAP_IMP} other.implementation as imp_other then
				a_gdkpixbuf := imp_other.pixbuf_from_drawable
				if other.width <= 16 and then other.height <= 16 then
						-- For small images this method scales better
					a_scale_type := {GTK2}.gdk_interp_nearest
				else
						-- For larger images this mode provides better scaling
					a_scale_type := {GTK2}.gdk_interp_bilinear
				end
				scaled_pixbuf := {GTK2}.gdk_pixbuf_scale_simple (a_gdkpixbuf, area.width, area.height, a_scale_type)
				{GTK2}.object_unref (a_gdkpixbuf)
				set_pixmap_from_pixbuf (scaled_pixbuf)
				{GTK2}.object_unref (scaled_pixbuf)
				check
					dimensions_match: height = area.height and width = area.width
				end
				set_is_initialized (True)
			end
		end

feature {NONE} -- Element change

	init_from_buffer (buffer: EL_PIXEL_BUFFER)
			-- Initialize from `pixel_buffer'
		local
			surface: CAIRO_PIXEL_SURFACE_IMP
		do
			if attached {EL_PIXEL_BUFFER_IMP} buffer.implementation as imp_buffer then
				surface := imp_buffer.to_pixel_surface
				surface.swap_blue_and_red
				set_pixmap_from_pixbuf (surface.gdk_pixel_buffer)
			end
		end

feature {EV_ANY, EV_ANY_I, EV_ANY_HANDLER} -- Implementation

	interface: detachable EL_PIXMAP note option: stable attribute end;

end
