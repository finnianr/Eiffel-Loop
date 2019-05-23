note
	description: "[
		A rotatable rectangle containing the outline of a Matroyshka doll representing a placeholder for an image
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-05-23 17:43:39 GMT (Thursday 23rd May 2019)"
	revision: "1"

class
	IMAGE_PLACEHOLDER_MODEL

inherit
	EV_MODEL_GROUP

	EL_MODULE_COLOR
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
			border, height: DOUBLE
		do
			default_create
			image_area := a_bounding
			image_area.set_foreground_color (Color.White)
			image_area.set_background_color (Color.Dark_gray)

			extend (image_area)
			extend (create {DOLL_MODEL}.make (image_area))
		end

feature -- Access

	border_percent: INTEGER

	image_area: EL_MODEL_ROTATED_RECTANGLE

end
