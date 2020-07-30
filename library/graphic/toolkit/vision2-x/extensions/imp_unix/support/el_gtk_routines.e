note
	description: "GTK routines accessible via [$source EL_MODULE_GTK]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-29 11:03:04 GMT (Wednesday 29th July 2020)"
	revision: "1"

class
	EL_GTK_ROUTINES

inherit
	EV_ANY_HANDLER

	EL_SHARED_ACCESS

feature -- Factory

	new_gdk_pixel_buffer (a_pixmap: EV_PIXMAP): POINTER
		local
			l_pixbuf: POINTER
		do
			if attached {EV_PIXMAP_IMP} a_pixmap.implementation as p then
				l_pixbuf := {GTK2}.gdk_pixbuf_get_from_drawable (
					default_pointer, Access.image_data (p), default_pointer, 0, 0, 0, 0, p.width, p.height
				)
				if {GTK2}.gdk_pixbuf_get_has_alpha (l_pixbuf) then
					Result := l_pixbuf
				else
					-- Make sure that the pixel data is internally stored as R G B A
					-- Is this compatible with Cairo graphics? Not sure.
					Result := {GTK2}.gdk_pixbuf_add_alpha (l_pixbuf, False, 0, 0, 0)
					{GTK2}.object_unref (l_pixbuf)
				end
			end
		end

	new_scaled_pixel_buffer (pixmap: EV_PIXMAP; area: EL_RECTANGLE): POINTER
			-- Stretch the image to fit in size `a_x' by `a_y'.
		local
			a_scale_type, l_width, l_height: INTEGER
			gdk_pixbuf: POINTER
		do
			l_width := pixmap.width; l_height := pixmap.height

			gdk_pixbuf := new_gdk_pixel_buffer (pixmap)

			if l_width /= area.width or else l_height /= area.height then
				if l_width <= 16 and then l_height <= 16 then
						-- For small images this method scales better
					a_scale_type := {GTK2}.gdk_interp_nearest
				else
						-- For larger images this mode provides better scaling
					a_scale_type := {GTK2}.gdk_interp_bilinear
				end
				Result := {GTK2}.gdk_pixbuf_scale_simple (gdk_pixbuf, area.width, area.height, a_scale_type)
				{GTK2}.object_unref (gdk_pixbuf)
			else
				Result := gdk_pixbuf
			end
		end

end
