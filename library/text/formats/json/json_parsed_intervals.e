note
	description: "Basic JSON parser that finds intervals of data values and identifiers"
	notes: "Group identifiers are ignored, so this is not a full recursive parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-18 8:27:48 GMT (Saturday 18th March 2023)"
	revision: "9"

class
	JSON_PARSED_INTERVALS

inherit
	EL_OCCURRENCE_INTERVALS
		rename
			make as make_intervals
		export
			{NONE} all
			{ANY} go_i_th, start, forth, after, off, count, index, valid_index, found
		end

	EL_SHARED_STRING_8_CURSOR

create
	make

feature {NONE} -- Initialization

	make (a_utf_8_json: READABLE_STRING_8)
		local
			i, j, index_quote, upper, json_count, colon_index: INTEGER
			valid_upper: BOOLEAN; c8: EL_CHARACTER_8_ROUTINES
			new_area, l_area: like area
		do
			json_count := a_utf_8_json.count
			make_intervals (a_utf_8_json, ':')
--			filter out any intervals that are not at the end of an identifier for data value
			l_area := area
			create new_area.make_empty (l_area.count)
			from i := 0 until i = l_area.count loop
				colon_index := l_area [i]
				upper := colon_index - 2
				if upper >= 1 and then c8.is_c_identifier (a_utf_8_json [upper], False) then
				-- is the last character of identifier followed by quote mark
					valid_upper := a_utf_8_json [upper + 1] = '"'
				else
					valid_upper := False
				end
				if valid_upper then
					from j := colon_index + 1 until j > json_count or else not a_utf_8_json [j].is_space loop
						j := j + 1
					end
					-- if not a group identifier
					if a_utf_8_json [j] /= '{' then
						index_quote := previous_index_of_end_quote (a_utf_8_json, upper - 1)
						if index_quote > 0 then
							new_area.extend (index_quote + 1)
							new_area.extend (upper)
						end
					end
				end
				i := i + 2
			end
			area_v2 := new_area
			data_intervals_area := new_data_intervals (a_utf_8_json, new_area, json_count).area
		ensure
			each_name_has_a_value: area_v2.count = data_intervals_area.count
		end

feature {NONE} -- Implementation

	index_of_balanced_bracket (json: READABLE_STRING_8; start_index, json_count: INTEGER): INTEGER
		local
			i, open_count, offset: INTEGER; l_area: like cursor_8.area
		do
			if attached cursor_8 (json) as c then
				l_area := c.area; offset := c.area_first_index
				from i := start_index until i > json_count or Result > 0 loop
					inspect l_area [i + offset - 1]
						when '[' then
							open_count := open_count + 1
							i := i + 1
							
						when ']' then
							if open_count = 0 then
								Result := i - 1
							else
								open_count := open_count - 1
								i := i + 1
							end
					else
						i := i + 1
					end
				end
			end
		end

	index_of_end_quote (json: READABLE_STRING_8; start_index, json_count: INTEGER): INTEGER
		local
			i, offset: INTEGER; l_area: like cursor_8.area
		do
			if attached cursor_8 (json) as c then
				l_area := c.area; offset := c.area_first_index
				from i := start_index until i > json_count or Result > 0 loop
					if l_area [i + offset - 1] = '"' and then l_area [i + offset] /= '/' then
						Result := i - 1
					else
						i := i + 1
					end
				end
			end
		end

	last_non_numeric_index (json: READABLE_STRING_8; start_index, json_count: INTEGER): INTEGER
		local
			i, offset: INTEGER; l_area: like cursor_8.area
		do
			if attached cursor_8 (json) as c then
				l_area := c.area; offset := c.area_first_index
				from i := start_index until i > json_count or Result > 0 loop
					inspect l_area [i + offset - 1]
						when '0' .. '9', '+', '-', '.', 'E', 'e' then
							i := i + 1
					else
						Result := i - 1
					end
				end
			end
		end

	previous_index_of_end_quote (json: READABLE_STRING_8; start_index: INTEGER): INTEGER
		local
			i, offset: INTEGER; l_area: like cursor_8.area
		do
			if attached cursor_8 (json) as c then
				l_area := c.area; offset := c.area_first_index
				from i := start_index until i = 0 or else l_area [i + offset - 1] = '"' loop
					i := i - 1
				end
			end
			Result := i
		end

	new_data_intervals (json: READABLE_STRING_8; intervals: like area; json_count: INTEGER): EL_ARRAYED_INTERVAL_LIST
		local
			i, j, lower, upper: INTEGER
		do
			create Result.make (count)
			from i := 0 until i = intervals.count loop
				upper := intervals [i + 1]
--				find first character that is not a space
				from j := upper + 3 until j > json_count or else not json [j].is_space loop
					j := j + 1
				end
				if j + 1 <= json_count then
					upper := 0
					inspect json [j]
						when '"' then -- quoted string
							lower := j + 1
							upper := index_of_end_quote (json, lower, json_count)

						when 't', 'f', 'n' then -- true, false or null
							if Standard_value_table.has_key (json [j])
								and then attached Standard_value_table.found_item as value
							then
								lower := j; upper := lower + value.count - 1
								if upper > json_count
									or else not json.same_characters (value, 1, value.count, lower)
								then
									upper := 0
								end
							end
						when '0' .. '9', '-' then -- numeric value
							lower := j
							upper := last_non_numeric_index (json, lower, json_count)

						when '[' then
							lower := j + 1
							upper := index_of_balanced_bracket (json, lower, json_count)

					else
					end
					if upper > 0 then
						Result.extend (lower, upper)
					end
				end
				i := i + 2
			end
		end

feature {NONE} -- Internal attributes

	data_intervals_area: SPECIAL [INTEGER]

feature {NONE} -- Constants

	Standard_value_table: EL_HASH_TABLE [STRING, CHARACTER]
		once
			create Result.make (<<
				['t', "true"],
				['f', "false"],
				['n', "null"]
			>>)
		end

invariant
	names_and_data_correspond: attached data_intervals_area as data implies area.count = data.count
end