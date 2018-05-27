note
	description: "Pixmap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_PIXMAP

inherit
	EV_PIXMAP
		redefine
			sub_pixmap, make_with_pixel_buffer
		end

	EL_MODULE_SCREEN
		undefine
			is_equal, default_create, copy
		end

	EL_DRAWABLE
		undefine
			is_equal, default_create, copy
		end

create
	default_create,
	make_with_size, make_with_pointer_style, make_with_pixel_buffer, make_with_rectangle,
	make_from_other, make_scaled_to_width, make_scaled_to_height

feature {NONE} -- Initialization

	make_with_rectangle (r: EL_RECTANGLE)
		do
			make_with_size (r.width, r.height)
		end

	make_from_other (other: like Current)
		do
			make_with_pixel_buffer (create {EV_PIXEL_BUFFER}.make_with_pixmap (other))
		end

	make_scaled_to_width (other: like Current; a_width: INTEGER)
		local
			pixels: EL_DRAWABLE_PIXEL_BUFFER; scale_factor: DOUBLE
		do
			scale_factor := a_width / other.width
			create pixels.make_rgb_24_with_size (a_width, (other.height * scale_factor).floor)
			pixels.lock
			pixels.draw_scaled_pixel_buffer (0, 0, scale_factor, other)
			pixels.unlock
			make_with_pixel_buffer (pixels)
		end

	make_scaled_to_height (other: like Current; a_height: INTEGER)
		local
			pixels: EL_DRAWABLE_PIXEL_BUFFER; scale_factor: DOUBLE
		do
			scale_factor := a_height / other.height
			create pixels.make_rgb_24_with_size ((other.width * scale_factor).floor, a_height)
			pixels.lock
			pixels.draw_scaled_pixel_buffer (0, 0, scale_factor, other)
			pixels.unlock
			make_with_pixel_buffer (pixels)
		end

	make_with_pixel_buffer (a_pixel_buffer: EV_PIXEL_BUFFER)
		do
			if attached {EL_DRAWABLE_PIXEL_BUFFER} a_pixel_buffer as drawable_buffer then
				Precursor (drawable_buffer.to_rgb_24_buffer)
			else
				Precursor (a_pixel_buffer)
			end
		end

feature -- Access

	file_path: EL_FILE_PATH
		do
			Result := pixmap_path
		end

feature -- Measurement setting

	scale_to_width (a_width: INTEGER)
		do
			scale (a_width / width)
		end

	scale_to_width_cms (a_width_cms: REAL)
		do
			scale (Screen.horizontal_pixels (a_width_cms) / width)
		end

	scale_to_height (a_height: INTEGER)
		do
			scale (a_height / height)
		end

	scale_to_height_cms (a_height_cms: REAL)
		do
			scale (Screen.vertical_pixels (a_height_cms) / height)
		end

	scale (a_factor: DOUBLE)
		local
			l_buffer: EV_PIXEL_BUFFER
		do
			create l_buffer.make_with_pixmap (Current)
			make_with_pixel_buffer (l_buffer.stretched ((width * a_factor).rounded, (height * a_factor).rounded))
--			stretch ((width * a_factor).rounded, (height * a_factor).rounded)
		end

feature -- Duplication

	sub_pixmap (area: EV_RECTANGLE): EL_PIXMAP
		do
			create Result.make_with_size (area.width, area.height)
			Result.draw_sub_pixmap (0, 0, Current, area)
		end

feature {NONE} -- Implementation

	redraw
		do
		end

end
