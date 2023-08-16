note
	description: "[
		List of all split-intervals in a string conforming to [$source READABLE_STRING_GENERAL]
		split by a string or character delimiter.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 6:24:23 GMT (Monday 7th August 2023)"
	revision: "21"

class
	EL_SPLIT_INTERVALS

inherit
	EL_OCCURRENCE_INTERVALS
		redefine
			extend_buffer
		end

create
	make, make_empty, make_by_string, make_sized, make_from_special

feature {NONE} -- Implementation

	extend_buffer (
		a_target: READABLE_STRING_GENERAL
		buffer: like Intervals_buffer; search_index, search_string_count, a_adjustments: INTEGER
		final: BOOLEAN
	)
		local
			start_index, end_index: INTEGER
			found_first: BOOLEAN
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
			if (a_adjustments & {EL_SIDE}.Left).to_boolean then
				from until found_first or else start_index > end_index loop
					if is_white_space (a_target, start_index) then
						start_index := start_index + 1
					else
						found_first := True
					end
				end
			end
			if (a_adjustments & {EL_SIDE}.Right).to_boolean then
				found_first := False
				from until found_first or else end_index < start_index  loop
					if is_white_space (a_target, end_index) then
						end_index := end_index - 1
					else
						found_first := True
					end
				end
			end
			buffer.extend (start_index, end_index)
		end

	is_white_space (a_target: READABLE_STRING_GENERAL; i: INTEGER): BOOLEAN
		do
			if attached {READABLE_STRING_8} a_target as str_8 then
				Result := str_8 [i].is_space
			else
				Result := Unicode_property.is_space (a_target [i])
			end
		end

end