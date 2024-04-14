note
	description: "Object that edits substring intervals of a ${STRING_32} instance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-14 18:19:41 GMT (Sunday 14th April 2024)"
	revision: "8"

class
	EL_STRING_32_OCCURRENCE_EDITOR

inherit
	EL_OCCURRENCE_EDITOR [STRING_32]
		rename
			string_scope as string_32_scope
		undefine
			bit_count, shared_cursor
		redefine
			default_target, target
		end

	EL_STRING_32_OCCURRENCE_INTERVALS
		rename
			item as interval_item,
			fill_by_string_32 as fill_intervals_by_string,
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

	EL_STRING_32_BIT_COUNTABLE [READABLE_STRING_32]

	EL_SHARED_STRING_32_BUFFER_SCOPES

	EL_SHARED_STRING_32_CURSOR

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := target ~ other.target and then Precursor {EL_STRING_32_OCCURRENCE_INTERVALS} (other)
		end

feature {NONE} -- Implementation

	default_target: STRING_32
		do
			Result := Empty_string_32
		end

	shared_cursor: EL_STRING_ITERATION_CURSOR
		do
			Result := Cursor_32 (target)
		end

	wipe_out_target
		do
			target.wipe_out
		end

feature {EL_OCCURRENCE_EDITOR} -- Internal attributes

	target: STRING_32

end