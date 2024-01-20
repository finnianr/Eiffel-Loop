note
	description: "Object that edits substring intervals of a ${STRING_8} instance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_STRING_8_OCCURRENCE_EDITOR

inherit
	EL_OCCURRENCE_EDITOR [STRING_8]
		rename
			string_scope as string_8_scope
		undefine
			bit_count, same_i_th_character
		redefine
			default_target, is_equal, shared_cursor, target
		end

	EL_STRING_8_OCCURRENCE_INTERVALS
		rename
			item as interval_item,
			fill_by_string as fill_intervals_by_string,
			make_empty as make_intervals,
			wipe_out as wipe_out_intervals
		undefine
			fill, make, make_by_string
		redefine
			is_equal
		end

	EL_SHARED_STRING_8_CURSOR

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := target ~ other.target and then Precursor {EL_STRING_8_OCCURRENCE_INTERVALS} (other)
		end

feature {NONE} -- Implementation

	default_target: STRING_8
		do
			Result := Empty_string_8
		end

	same_i_th_character (a_target: STRING_8; i: INTEGER; uc: CHARACTER_32): BOOLEAN
		do
			Result := a_target [i] = uc.to_character_8
		end

	shared_cursor: EL_STRING_ITERATION_CURSOR
		do
			Result := Cursor_8 (target)
		end

	wipe_out_target
		do
			target.wipe_out
		end

feature {EL_OCCURRENCE_EDITOR} -- Internal attributes

	target: STRING_8

end