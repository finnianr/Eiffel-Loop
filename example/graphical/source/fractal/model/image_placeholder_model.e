note
	description: "[
		A rotatable rectangle containing the outline of a Matroyshka doll representing a placeholder for an image
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-29 17:51:15 GMT (Wednesday 29th May 2019)"
	revision: "3"

class
	IMAGE_PLACEHOLDER_MODEL

inherit
	EV_MODEL_GROUP

	MODEL_CONSTANTS
		undefine
			default_create
		end

	EL_ORIENTATION_CONSTANTS
		undefine
			default_create
		end

create
	make, make_within_bounds, make_satellite

feature {NONE} -- Initialization

	make (rectangle: EL_RECTANGLE)
		do
			make_within_bounds (rectangle)
		end

	make_satellite (other: like Current; size_proportion, displaced_radius_proportion, relative_angle: DOUBLE)
		local
			rectangle: EL_MODEL_ROTATED_RECTANGLE
			l_distance: DOUBLE
		do
			create rectangle.make_from_other (other.image_area)
			rectangle.scale (size_proportion)
			l_distance := other.image_area.radius * displaced_radius_proportion + rectangle.radius
			rectangle.displace (l_distance, relative_angle)

			make_within_bounds (rectangle)
		end

	make_within_bounds (a_bounding: EL_MODEL_ROTATED_RECTANGLE)
		local
			head: DOLL_HEAD_MODEL; base: EL_MODEL_ROTATED_SQUARE_PICTURE
			doll: EV_MODEL_GROUP
		do
			default_create
			image_area := a_bounding
			image_area.set_foreground_color (Color.White)
			image_area.set_background_color (Color_placeholder)

			extend (image_area)

			if image_area.height >= image_area.width then
				create head.make (image_area, Top, Doll_head_pixels, Color_placeholder)
				doll.extend (head)
				create base.make (image_area, Top, Doll_base_pixels, Color_placeholder)
				base.set_x_y_precise (head.mid_point_bottom)
				doll.put_front (base)
			else
				create head.make (image_area, Left, Doll_head_pixels, Color_placeholder)
				if image_area.width > image_area.height * 1.7 then
					create base.make (image_area, Right, Doll_base_pixels, Color_placeholder)
					extend (base)
				else
					head.move_to_center (image_area)
				end
			end
			extend (doll)
		end

feature -- Access

	border_percent: INTEGER

	image_area: EL_MODEL_ROTATED_RECTANGLE

end
