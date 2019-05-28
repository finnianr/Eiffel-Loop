note
	description: "Doll base model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-27 14:49:30 GMT (Monday 27th May 2019)"
	revision: "1"

class
	DOLL_BASE_MODEL

inherit
	DOLL_MODEL

create
	make

feature {NONE} -- Implementation

	set_point_array (rectangle: EL_MODEL_ROTATED_RECTANGLE; alpha, diameter: DOUBLE)
		local
			p2, p3: EV_COORDINATE
		do
			p2 := point_array [2]
			p3 := point_array [3]
			point_array [0] := point_on_circle (p3, alpha - radians (90), diameter)
			point_array [1] := point_on_circle (p2, alpha - radians (90), diameter)
		end

feature {NONE} -- Constants

	Pixel_buffer: EL_DRAWABLE_PIXEL_BUFFER
		once
			create Result.make_with_path (Image.image_path ("doll-base.png"))
		end

	Pixmap_table: HASH_TABLE [EV_PIXMAP, INTEGER_64]
		once
			create Result.make (50)
		end

end
