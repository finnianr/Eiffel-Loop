note
	description: "Object that edits substring intervals of a ${STRING_8} instance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 7:03:47 GMT (Sunday 6th April 2025)"
	revision: "11"

class
	EL_STRING_8_OCCURRENCE_EDITOR

inherit
	EL_OCCURRENCE_EDITOR [STRING_8]
		rename
			string_pool as String_8_pool,
			extended_string as super_readable_8
		undefine
			bit_count, same_i_th_character
		redefine
			default_target, is_equal, target
		end

	EL_STRING_8_OCCURRENCE_INTERVALS
		rename
			item as interval_item,
			fill_by_string_8 as fill_intervals_by_string,
			fill_by_string as fill_by_zstring,
			make_empty as make_intervals,
			wipe_out as wipe_out_intervals
		export
			{NONE} all
			{ANY} count, index
		undefine
			fill, make, make_by_string
		redefine
			is_equal
		end

	EL_SHARED_STRING_8_BUFFER_POOL

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