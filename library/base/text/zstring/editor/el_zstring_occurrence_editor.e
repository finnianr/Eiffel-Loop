note
	description: "Object that edits substring intervals of a ${ZSTRING} instance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 10:33:47 GMT (Sunday 25th August 2024)"
	revision: "8"

class
	EL_ZSTRING_OCCURRENCE_EDITOR

inherit
	EL_OCCURRENCE_EDITOR [ZSTRING]
		undefine
			shared_cursor
		redefine
			default_target, is_equal, target
		end

	EL_ZSTRING_OCCURRENCE_INTERVALS
		rename
			item as interval_item,
			fill_by_string as fill_intervals_by_string,
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

	EL_SHARED_ZSTRING_BUFFER_SCOPES

	EL_SHARED_ZSTRING_CURSOR

create
	make, make_empty, make_by_string, make_adjusted, make_adjusted_by_string

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := target ~ other.target and then Precursor {EL_ZSTRING_OCCURRENCE_INTERVALS} (other)
		end

feature {NONE} -- Implementation

	default_target: ZSTRING
		do
			Result := Empty_string
		end

	shared_cursor: EL_STRING_ITERATION_CURSOR
		do
			Result := cursor_z (target)
		end

	wipe_out_target
		do
			target.wipe_out
		end

feature {EL_OCCURRENCE_EDITOR} -- Internal attributes

	target: ZSTRING

end