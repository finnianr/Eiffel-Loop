note
	description: "[
		List of all split-intervals in a string conforming to ${READABLE_STRING_GENERAL}
		split by a string or character delimiter.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 7:08:50 GMT (Sunday 4th May 2025)"
	revision: "28"

class
	EL_SPLIT_INTERVALS

inherit
	EL_OCCURRENCE_INTERVALS
		redefine
			extend_buffer
		end

create
	make, make_adjusted, make_empty, make_by_string, make_sized, make_from_special

feature {NONE} -- Initialization

	make_adjusted (target: READABLE_STRING_GENERAL; delimiter: CHARACTER_32; adjustments: INTEGER)
		-- make intervals with white space adjustments: `Both_sides', `Left_side', `No_sides', `Right_side'
		-- See class `EL_SIDE_ROUTINES'
		require
			valid_adjustments: valid_adjustments (adjustments)
		do
			make_empty
			fill (target, delimiter, adjustments)
		ensure
			valid_indices: valid_indices (target)
		end

feature -- Contract Support

	valid_indices (target: READABLE_STRING_GENERAL): BOOLEAN
		-- True if all non-zero intervals are valid indices for `target' string
		do
			push_cursor
			Result := True
			from start until after or not Result loop
				if item_count > 0 then
					Result := target.valid_index (item_lower) and target.valid_index (item_lower)
				end
				forth
			end
			pop_cursor
		end

feature {NONE} -- Implementation

	extend_buffer (
		a_target: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		buffer: like Intervals_buffer; search_index, search_string_count, adjustments: INTEGER
		final: BOOLEAN
	)
		local
			start_index, end_index: INTEGER
		do
			if final then
				if search_index = 0 then
					start_index := 1; end_index := a_target.count
				else
					start_index := search_index + search_string_count; end_index := a_target.count
				end
			else
				if buffer.is_empty then
					start_index := 1; end_index := search_index - 1
				else
					start_index := buffer.last_upper + search_string_count + 1
					end_index := search_index - 1
				end
			end
			if (adjustments & {EL_SIDE}.Left).to_boolean and then start_index <= a_target.count then
				start_index := start_index + a_target.leading_white_count_in_bounds (start_index, end_index)
			end
			if (adjustments & {EL_SIDE}.Right).to_boolean then
				end_index := end_index - a_target.trailing_white_count_in_bounds (start_index, end_index)
			end
			buffer.extend (start_index, end_index)
		end

end