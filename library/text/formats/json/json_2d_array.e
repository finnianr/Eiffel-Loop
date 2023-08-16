note
	description: "Parse 2 dimensional array of JSON numeric tuples"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-06 16:03:51 GMT (Sunday 6th August 2023)"
	revision: "3"

class
	JSON_2D_ARRAY [N -> NUMERIC]

inherit
	ARRAY2 [N]
		rename
			make as make_array,
			lower as lower_index,
			upper as upper_index
		end

	EL_MODULE_CONVERT_STRING

create
	make

feature {NONE} -- Initialization

	make (json: IMMUTABLE_STRING_8)
		local
			split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
			l_width, row, column, zero_index: INTEGER; value: IMMUTABLE_STRING_8
		do
			create split_list.make_adjusted (json, ',', {EL_SIDE}.Both)
			if attached split_list as list then
				from list.start until list.after or l_width > 0 loop
					if list.item_has (']') then
						l_width := list.index
					else
						list.forth
					end
				end
				if l_width > 0 and then list.count \\ l_width = 0 then
					make_filled (({N}).default, list.count // l_width, l_width)
					from list.start until list.after loop
						value := pruned_value (json, list.item_lower, list.item_upper)
						zero_index := list.index - 1
						row := zero_index // l_width + 1
						column := zero_index \\ l_width + 1
						if attached {N} Convert_string.to_type (value, {N}) as number then
							put (number, row, column)
						end
						list.forth
					end
				else
					make_empty
				end
			end
		end

feature {NONE} -- Implementation

	pruned_value (json: IMMUTABLE_STRING_8; start_index, end_index: INTEGER): IMMUTABLE_STRING_8
		-- prune spaces and brackets from left and right
		local
			lower, upper, i: INTEGER; c: CHARACTER
		do
			from i := start_index until i > end_index or lower > 0 loop
				c := json [i]
				inspect c
					when '[', ']', ' ', '%T', '%N' then
						i := i + 1
				else
					if c.is_space then
						i := i + 1
					else
						lower := i
					end
				end
			end
			from i := end_index until i < start_index or upper > 0 loop
				c := json [i]
				inspect c
					when '[', ']', ' ', '%T', '%N' then
						i := i - 1
				else
					if c.is_space then
						i := i - 1
					else
						upper := i
					end
				end
			end
			if lower > 0 and upper > 0 then
				Result := json.shared_substring (lower, upper)
			else
				create Result.make_filled ('0', 1)
			end
		end
end