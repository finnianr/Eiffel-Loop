note
	description: "Constants identifiying side of an object that can be combined with ''bit_or'' operator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-20 10:35:54 GMT (Monday 20th March 2023)"
	revision: "1"

deferred class
	EL_SIDE_ROUTINES

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Both_sides: INTEGER = 3

	Left_side: INTEGER = 1

	No_sides: INTEGER = 0

	Right_side: INTEGER = 2

feature {NONE} -- Contract Support

	frozen valid_sides (bitmap: INTEGER): BOOLEAN
		do
			Result := No_sides <= bitmap and then bitmap <= Both_sides
		end

	frozen valid_side_left_or_right (bitmap: INTEGER): BOOLEAN
		do
			inspect bitmap
				when Left_side, Right_side then
					Result := True
			else
			end
		end

	frozen has_left_side (bitmap: INTEGER): BOOLEAN
		do
			Result := (bitmap & Left_side).to_boolean
		end

	frozen has_right_side (bitmap: INTEGER): BOOLEAN
		do
			Result := (bitmap & Right_side).to_boolean
		end

invariant
	left_is_one: Left_side = 1 -- Allows `left_adjusted.to_integer'
end