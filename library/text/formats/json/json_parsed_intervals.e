note
	description: "List of JSON name and value substring intervals"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-12 10:51:53 GMT (Sunday 12th March 2023)"
	revision: "6"

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

create
	make

feature {NONE} -- Initialization

	make (a_utf_8_json: READABLE_STRING_8)
		local
			i, j, upper, json_count, delimiter_upper, delimiter_lower: INTEGER; valid_upper: BOOLEAN
		do
			json_count := a_utf_8_json.count
			make_by_string (a_utf_8_json, Name_ending)
--			remove escaped matches of quote \": and adjust interval to the name
			if attached area.twin as a then
--				remake intervals `area_v2' to be only names of values
				area_v2.wipe_out
				from i := 0 until i = a.count loop
					delimiter_lower := a [i]; delimiter_upper := a [i + 1]

					upper := delimiter_lower - 1
					valid_upper := a_utf_8_json.valid_index (upper)
					if valid_upper and then a_utf_8_json [upper] = '\' then
						do_nothing

					elseif valid_upper then
						from j := delimiter_upper + 1 until j > json_count or else not a_utf_8_json [j].is_space loop
							j := j + 1
						end
						if a_utf_8_json [j] = '{' then
							do_nothing
						else
							from j := upper - 1 until j = 0 or else a_utf_8_json [j] = '"' loop
								j := j - 1
							end
							extend (j + 1, upper)
						end
					end
					i := i + 2
				end
			end
			data_intervals_area := new_data_intervals (a_utf_8_json, json_count).area
		ensure
			each_name_has_a_value: area_v2.count = data_intervals_area.count
		end

feature {NONE} -- Implementation

	new_data_intervals (a_utf_8_json: READABLE_STRING_8; json_count: INTEGER): EL_ARRAYED_INTERVAL_LIST
		local
			i, j, lower, upper: INTEGER
			l_found: BOOLEAN
		do
			create Result.make (count)
			if attached area_v2 as a then
				from i := 0 until i = a.count loop
					upper := a [i + 1]
					from j := upper + 3 until j > json_count or else not a_utf_8_json [j].is_space loop
						j := j + 1
					end
					if j + 1 <= json_count then
						upper := 0
						inspect a_utf_8_json [j]
							when '"' then -- quoted string
								lower := j + 1; l_found := False
								from j := lower until j > json_count or upper > 0 loop
									if a_utf_8_json [j] = '"' and then a_utf_8_json [j - 1] /= '/' then
										upper := j - 1
									else
										j := j + 1
									end
								end
							when 't', 'f', 'n' then -- true, false or null
								if Standard_value_table.has_key (a_utf_8_json [j])
									and then attached Standard_value_table.found_item as value
								then
									lower := j; upper := lower + value.count - 1
									if upper > json_count
										or else not a_utf_8_json.same_characters (value, 1, value.count, lower)
									then
										upper := 0
									end
								end
							when '0' .. '9', '-' then -- numeric value
								lower := j; l_found := False
								from until j > json_count or upper > 0 loop
									inspect a_utf_8_json [j]
										when '0' .. '9', '-', '.' then
											j := j + 1
									else
										upper := j - 1
									end
								end
						else
						end
						if upper > 0 then
							Result.extend (lower, upper)
						end
					end
					i := i + 2
				end
			end
		end

feature {NONE} -- Internal attributes

	data_intervals_area: SPECIAL [INTEGER]

feature {NONE} -- Constants

	Name_ending: STRING = "%":"

	Standard_value_table: EL_HASH_TABLE [STRING, CHARACTER]
		once
			create Result.make (<<
				['f', "false"],
				['t', "true"],
				['n', "null"]
			>>)
		end

invariant
	names_and_data_correspond: attached data_intervals_area as data implies area.count = data.count
end