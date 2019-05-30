note
	description: "Replicated image model"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-30 13:43:40 GMT (Thursday 30th May 2019)"
	revision: "1"

class
	REPLICATED_IMAGE_MODEL

inherit
	EL_MODEL_ROTATED_PICTURE
		redefine
			make
		end

	MODEL_CONSTANTS
		undefine
			default_create
		end

create
	make, make_satellite

feature {NONE} -- Initialization

	make (a_points: EL_COORDINATE_ARRAY; a_pixel_buffer: like pixel_buffer)
		do
			Precursor (a_points, a_pixel_buffer)
			set_foreground_color (Color.White)
--			set_background_color (Color_placeholder)
		end

	make_satellite (other: like Current; size_proportion, displaced_radius_proportion, relative_angle: DOUBLE)
		local
			l_distance: DOUBLE
		do
			make_from_other (other)
			scale (size_proportion)
			l_distance := other.radius * displaced_radius_proportion + radius
			displace (l_distance, relative_angle)
		end

end
