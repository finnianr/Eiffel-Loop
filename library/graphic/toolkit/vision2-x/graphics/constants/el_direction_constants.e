note
	description: "${EL_DIRECTION} constants for inheritance by class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-14 10:10:12 GMT (Wednesday 14th February 2024)"
	revision: "1"

deferred class
	EL_DIRECTION_CONSTANTS

inherit
	EL_DIRECTION
		rename
			Bottom_left as Bottom_left_corner,
			Bottom_right as Bottom_right_corner,
			Bottom as Bottom_side,
			Center as Center_position,
			Left as Left_side,
			Right as Right_side,
			Top_left as Top_left_corner,
			Top_right as Top_right_corner,
			Top as Top_side
		export
			{NONE} all
		undefine
			copy, default_create, is_equal, out
		end

end