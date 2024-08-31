note
	description: "[
		Archived version ${EL_COMPARABLE_ZSTRING} used in ${ZSTRING_SAME_CHARACTERS_COMPARISON}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-17 11:09:56 GMT (Friday 17th February 2023)"
	revision: "26"

deferred class
	EL_COMPARABLE_ZSTRING

feature -- Comparison

	same_characters_zstring (other: EL_READABLE_ZSTRING; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- the same characters of current string starting at index `start_index'
		local
			i, l_count: INTEGER; l_area, o_area: like area
			unencoded, o_unencoded: like unencoded_indexable
			uc, uc_other: CHARACTER_32
		do
			l_area := area; o_area := other.area
			l_count := end_pos - start_pos + 1
			Result := internal_same_characters (other, start_pos, end_pos, start_index)
			if Result and then has_unencoded_between_optimal (l_area, start_index, start_index + l_count - 1) then
				if other.has_unencoded_between_optimal (o_area, start_pos, end_pos) then
					unencoded := unencoded_indexable; o_unencoded := other.unencoded_indexable_other
--					check substitutions
					from i := 0 until not Result or else i = l_count loop
						if l_area [start_index + i - 1] = Substitute then
							uc := unencoded.item (start_index + i); uc_other := o_unencoded.item (start_pos + i)
							Result := uc = uc_other
						end
						i := i + 1
					end
				else
					Result := False
				end
			end
		end

	same_characters_zstring_1 (other: EL_READABLE_ZSTRING; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- the same characters of current string starting at index `start_index'
		local
			end_index: INTEGER
		do
			end_index := start_index + end_pos - start_pos
			if internal_same_characters (other, start_pos, end_pos, start_index) then
				Result := same_unencoded_characters (other.unencoded_indexable_other, start_index, end_index, start_pos - start_index)
			end
		end

	same_characters_zstring_2 (other: EL_READABLE_ZSTRING; start_pos, end_pos, start_index: INTEGER): BOOLEAN
		-- Are characters of `other' within bounds `start_pos' and `end_pos'
		-- the same characters of current string starting at index `start_index'
		local
			i, l_count, end_index, current_i, other_i: INTEGER
			l_unencoded_area, other_unencoded_area: like unencoded_area
			intervals, other_intervals: EL_ZSTRING_INTERVALS
			unencoded_sources, other_unencoded_sources: SPECIAL [INTEGER_64]
		do
			end_index := start_index + end_pos - start_pos
			if end_index <= count then
				other_intervals := other.shared_interval_list (start_pos, end_pos).twin
				intervals := shared_interval_list (start_index, end_index)

				if intervals.similar_to (other_intervals) then
					Result := intervals.same_encoded_characters (area, other.area, other_intervals)
				end
				if Result then
					l_unencoded_area := unencoded_area; other_unencoded_area := other.unencoded_area
					unencoded_sources := intervals.new_unencoded_sources (start_index, end_index)
					other_unencoded_sources := other_intervals.new_unencoded_sources (start_pos, end_pos)
					from i := 0 until not Result or i = unencoded_sources.count loop
						current_i := (unencoded_sources [i] |>> 32).to_integer_32
						l_count := unencoded_sources [i].to_integer_32
						other_i := (other_unencoded_sources [i] |>> 32).to_integer_32
						Result := l_unencoded_area.same_items (other_unencoded_area, other_i, current_i, l_count)
						i := i + 1
					end
				end
			end
		end

end
