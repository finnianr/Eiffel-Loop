note
	description: "Unix implementation of [$source CAIRO_DRAWING_AREA_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-21 10:03:10 GMT (Friday 21st August 2020)"
	revision: "5"

class
	CAIRO_DRAWING_AREA_IMP

inherit
	CAIRO_DRAWING_AREA_I
		rename
			remove_clip as reset_clip,
			set_angle as rotate
		end

	CAIRO_DRAWING_CONTEXT_IMP
		rename
			make as make_cairo_context
		end

	EL_OS_IMPLEMENTATION

create
	make

feature -- Conversion

	to_buffer: EV_PIXEL_BUFFER
		local
			l_surface: CAIRO_PIXEL_SURFACE_I
		do
			create Result.make_with_size (width, height)
			create {CAIRO_PIXEL_SURFACE_IMP} l_surface.make_with_buffer (Result)
			l_surface.new_context.draw_surface (0, 0, surface)
			l_surface.adjust_colors
			l_surface.destroy
		end

end
