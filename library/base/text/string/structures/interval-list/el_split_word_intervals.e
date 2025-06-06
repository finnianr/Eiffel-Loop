note
	description: "[
		List of all split-intervals in a string where the delimiter is a variable length of white space characters.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 7:09:02 GMT (Sunday 4th May 2025)"
	revision: "3"

class
	EL_SPLIT_WORD_INTERVALS

inherit
	EL_SPLIT_INTERVALS
		rename
			fill as fill_split,
			make as make_split
		export
			{NONE} fill_by_string, fill_by_string_32, fill_by_string_8, fill_split
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (target: READABLE_STRING_GENERAL)
		do
			make_empty
			fill (target)
		end

feature -- Measurement

	word_count (target: READABLE_STRING_GENERAL; exclude_variable_references: BOOLEAN): INTEGER
		-- count of all substrings of `target' string that have at least one alphabetical character.
		-- If `exclude_variable_references' is `True', exclude any substrings that take either of
		-- the forms: ${name} OR $name
		require
			valid_target: valid_substring_bounds (target)
		local
			i, start_index, end_index: INTEGER
		do
			if attached area_v2 as a and then attached super_readable_general (target) as super_target then
				from until i = a.count loop
					start_index := a [i]; end_index := a [i + 1]
					if super_target.has_alpha_in_bounds (start_index, end_index) then
						Result := Result + 1
						if exclude_variable_references
							and then super_target.is_variable_reference_substring (start_index, end_index)
						then
							Result := Result - 1
						end
					end
					i := i + 2
				end
			end
		end

feature -- Basic operations

	fill (target: READABLE_STRING_GENERAL)
		local
			i, i_upper, l_count, previous_pattern_count, pattern_count, search_index, trailing_white_count: INTEGER
		do
			if attached Intervals_buffer as l_area then
				l_area.wipe_out
				if target.count > 0 then
					l_count := target.count
					if attached super_readable_general (target) as super_target then
						trailing_white_count := super_target.trailing_white_count
						i_upper := l_count - trailing_white_count
						from i := 1 until i = 0 or else i > i_upper loop
							i := super_target.index_of_white (i)
							if i > 0 then
								search_index := i
								if i > l_count then
									pattern_count := 0
								else
									pattern_count := super_target.leading_white_count_in_bounds (i, i_upper)
								end
								extend_buffer (super_target, l_area, search_index, previous_pattern_count, 0, False)
								previous_pattern_count := pattern_count
								i := i + pattern_count
							end
						end
						if trailing_white_count > 0 then
							l_area.extend (l_count, l_count - 1)

						elseif search_index <= l_count then
							extend_buffer (super_target, l_area, search_index, previous_pattern_count, 0, True)
						end
					end
				end
				make_sized (l_area.count)
				area.copy_data (l_area.area, 0, 0, l_area.count * 2)
			end
		end
end