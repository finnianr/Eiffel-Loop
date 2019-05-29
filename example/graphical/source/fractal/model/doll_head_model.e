note
	description: "Doll model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-29 17:47:17 GMT (Wednesday 29th May 2019)"
	revision: "3"

class
	DOLL_HEAD_MODEL

inherit
	EL_MODEL_ROTATED_SQUARE_PICTURE
		redefine
			new_pixels_buffer
		end

	MODEL_CONSTANTS
		undefine
			default_create
		end

create
	make

feature -- Access

	mid_point_bottom: EV_COORDINATE
		do
			Result := point_on_circle (center, angle + radians (90), radius * 0.9)
		end

feature {NONE} -- Implementation

	new_pixels_buffer (a_width: INTEGER): EL_DRAWABLE_PIXEL_BUFFER
		-- Paint corners with `Color_skirt' if bottom of graphic is approx. pointing at tile corner
		local
			alpha: INTEGER; quadrant_key: INTEGER
		do
			Result := Precursor (a_width)
			alpha := ((angle / radians (360) * 360).rounded + 90) \\ 360
			across Quadrant_intervals as quadrant until quadrant_key > 0 loop
				if quadrant.item.has (alpha) then
					Result.set_color (Color_skirt)
					Result.fill_convex_corners ((radius / 2).rounded, quadrant.key)
				end
			end
		end

feature {NONE} -- Constants

	Quadrant_intervals: EL_HASH_TABLE [INTEGER_INTERVAL, INTEGER]
		once
			create Result.make (<<
				[Top_left_corner, 190 |..| 260],
				[Top_right,			280 |..| 350],
				[Bottom_right,		10  |..| 80],
				[Bottom_left,		100 |..| 170]
			>>)
		end
end
