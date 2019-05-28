note
	description: "Doll model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-28 15:51:29 GMT (Tuesday 28th May 2019)"
	revision: "2"

class
	DOLL_HEAD_MODEL

inherit
	DOLL_MODEL
		redefine
			new_pixels_buffer
		end

create
	make

feature {NONE} -- Implementation

	new_pixels_buffer (a_width: INTEGER): EL_DRAWABLE_PIXEL_BUFFER
		-- Paint corners with `Color_skirt' if bottom of graphic is approx. pointing at corner
		local
			alpha: INTEGER; quadrant_key: INTEGER
		do
			Result := Precursor (a_width)
			alpha := ((angle / (2 * Pi)  * 360).rounded + 90) \\ 360
			across Quadrant_intervals as quadrant until quadrant_key > 0 loop
				if quadrant.item.has (alpha) then
					Result.set_color (Color_skirt)
					Result.fill_convex_corners ((radius / 2).rounded, quadrant.key)
				end
			end
		end

	set_point_array (rectangle: EL_MODEL_ROTATED_RECTANGLE; alpha, diameter: DOUBLE)
		local
			p0, p1: EV_COORDINATE
		do
			p0 := point_array [0]
			p1 := point_array [1]
			point_array [3] := point_on_circle (p0, alpha + radians (90), diameter)
			point_array [2] := point_on_circle (p1, alpha + radians (90), diameter)
		end

feature {NONE} -- Constants

	Pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER
		once
			create Result.make_with_path (Image.image_path ("doll-head.png"))
		end

	Pixmap_table: HASH_TABLE [EV_PIXMAP, INTEGER_64]
		once
			create Result.make (50)
		end

	Quadrant_intervals: EL_HASH_TABLE [INTEGER_INTERVAL, INTEGER]
		once
			create Result.make (<<
				[Top_left_corner, 190 |..| 260],
				[Top_right, 280 |..| 350],
				[Bottom_right, 10 |..| 80],
				[Bottom_left, 100 |..| 170]
			>>)
		end
end
