note
	description: "[
		Table of ${EL_ZSTRING} strings with keys of type ${STRING_8} and createable from
		parsed general text with format
		
			key_1:
				Value One Line 1
				Value One Line 2
				..
			key_2:
				Value Two
				etc
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-21 13:46:31 GMT (Sunday 21st July 2024)"
	revision: "18"

class
	EL_ZSTRING_TABLE

inherit
	EL_HASH_TABLE [ZSTRING, STRING]
		rename
			make as make_from_array
		end

	EL_STRING_GENERAL_ROUTINES

	EL_CHARACTER_8_CONSTANTS

create
	make, make_size, make_from_array

feature {NONE} -- Initialization

	make (table_text: READABLE_STRING_GENERAL)
		local
			key_value_map_list: EL_TABLE_INTERVAL_MAP_LIST
			key: STRING; value: ZSTRING; ir: EL_INTERVAL_ROUTINES
		do
			create key_value_map_list.make (table_text)
			make_equal (key_value_map_list.count)
			if attached key_value_map_list as list then
				from list.start until list.after loop
					key := table_text.substring (ir.to_lower (list.item_key), ir.to_upper (list.item_key)).to_string_8
					value := as_zstring (table_text.substring (ir.to_lower (list.item_value), ir.to_upper (list.item_value)))
					if attached value.substring_index_list (New_line_tab, False) as index then
						from index.finish until index.before loop
							value.remove (index.item + 1)
							index.back
						end
						value.remove (1)
					end
					put (value, key)
					list.forth
				end
			end
		ensure
			corresponds_to_text: table_text.count > 0 implies corresponds_to_text (table_text)
		end

feature -- Access

	name_list: EL_STRING_8_LIST
		do
			create Result.make_from_array (current_keys)
		end

feature {NONE} -- Contract Support

	corresponds_to_text (table_text: READABLE_STRING_GENERAL): BOOLEAN
		do
			if item_list.sum_integer (agent line_count) + count = table_text.occurrences ('%N') + 1 then
				Result := across current_keys as key all
					table_text.has_substring (key.item + char (':'))
				end
			end
		end

feature {NONE} -- Implementation

	line_count (str: ZSTRING): INTEGER
		do
			Result := str.occurrences ('%N') + 1
		end

feature {NONE} -- Constants

	New_line_tab: ZSTRING
		once
			Result := "%N%T"
		end
end