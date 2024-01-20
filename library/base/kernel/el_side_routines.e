note
	description: "Routines for validating integer arguments that correspond to constants in ${EL_SIDE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	EL_SIDE_ROUTINES

inherit
	EL_SIDE
		rename
			Both as Both_sides,
			Left as Left_side,
			None as No_sides,
			Right as Right_side
		export
			{NONE} all
		undefine
			copy, default_create, is_equal, out
		end

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