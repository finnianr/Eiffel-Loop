note
	description: "Object that edits substring intervals of a [$source ZSTRING] instance"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 7:21:30 GMT (Monday 7th August 2023)"
	revision: "3"

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
		undefine
			fill, make, make_by_string
		redefine
			is_equal
		end

	EL_SHARED_ZSTRING_CURSOR
		rename
			Cursor as Z_cursor
		end

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

	reuseable_scope: like Reuseable.string
		do
			Result := Reuseable.string
		end

	shared_cursor: EL_STRING_ITERATION_CURSOR
		do
			Result := Z_cursor (target)
		end

	wipe_out_target
		do
			target.wipe_out
		end

feature {EL_OCCURRENCE_EDITOR} -- Internal attributes

	target: ZSTRING

end