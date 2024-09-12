note
	description: "Routines for validating integer arguments that correspond to constants in ${EL_SIDE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-12 17:18:54 GMT (Thursday 12th September 2024)"
	revision: "5"

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

feature {NONE} -- Implementation

	side_name (a_side: INTEGER): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.selected (a_side, 0 |..| Both_sides, "None, Left, Right, Both")
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

	frozen valid_sides (bitmap: INTEGER): BOOLEAN
		do
			Result := No_sides <= bitmap and then bitmap <= Both_sides
		end

invariant
	left_is_one: Left_side = 1 -- Allows `left_adjusted.to_integer'
end