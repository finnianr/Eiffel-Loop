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
			height as buffer_height,
			unlock as unlock_buffer
		undefine
			lock, default_create
		redefine
			interface, old_make, make
		end

	EL_DRAWABLE_PIXEL_BUFFER_I
		redefine
			unlock, interface, check_font_availability
		select
			make_with_pixmap, unlock
		end

	EL_MODULE_SYSTEM_FONTS
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

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

	check_font_availability
		local
			substitute_fonts: like System_fonts.Substitute_fonts
		do
			substitute_fonts := System_fonts.Substitute_fonts
			substitute_fonts.search (font.name)
			if substitute_fonts.found then
				font.preferred_families.start
				font.preferred_families.replace (substitute_fonts.found_item.to_unicode)
			end
		end

	stride: INTEGER
		do
			Result := data.stride
		end

	unlock
		do
			if is_locked then
				Precursor {EL_DRAWABLE_PIXEL_BUFFER_I}
				unlock_buffer
			end
		end

feature {NONE} -- Constants

	Pango_font_scale_factor: REAL = 1.01

end
