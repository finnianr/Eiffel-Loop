note
	description: "Routines for validating integer arguments that correspond to constants in ${EL_SIDE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 8:29:18 GMT (Saturday 5th April 2025)"
	revision: "7"

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

	EL_STRING_GENERAL_ROUTINES_I
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	side_name (a_side: INTEGER): STRING
		require
			valid_side: valid_side (a_side)
		do
			Result := super_8 (once "None, Left, Right, Both").selected_substring (a_side, 0 |..| Both_sides)
		end

feature {NONE} -- Contract Support

	frozen has_left_side (bitmap: INTEGER): BOOLEAN
		do
			Result := (bitmap & Left_side).to_boolean
		end

	frozen has_right_side (bitmap: INTEGER): BOOLEAN
		do
			Result := (bitmap & Right_side).to_boolean
		end

	frozen valid_side_left_or_right (bitmap: INTEGER): BOOLEAN
		do
			inspect bitmap
				when Left_side, Right_side then
					Result := True
			else
			end
		end

	frozen valid_side (bitmap: INTEGER): BOOLEAN
		do
			Result := No_sides <= bitmap and then bitmap <= Both_sides
		end

invariant
	left_is_one: Left_side = 1 -- Allows `left_adjusted.to_integer'
end