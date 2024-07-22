note
	description: "[
		An ${EL_ARRAYED_MAP_LIST} of compact substring intervals mapping table keys to table
		values in general text with following format:

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
	date: "2024-07-21 18:01:23 GMT (Sunday 21st July 2024)"
	revision: "2"

class
	EL_TABLE_INTERVAL_MAP_LIST

inherit
	EL_ARRAYED_MAP_LIST [INTEGER_64, INTEGER_64]
		rename
			make as make_sized
		end

create
	make

feature {NONE} -- Initialization

	make (table_text: READABLE_STRING_GENERAL)
		local
			value_start_index, value_end_index, start_index, end_index, line_count: INTEGER
			list: EL_SPLIT_INTERVALS; ir: EL_INTERVAL_ROUTINES; key_interval: INTEGER_64
			rs: EL_READABLE_STRING_GENERAL_ROUTINES
		do
			create list.make (table_text, '%N')
			make_sized (list.count)
			if attached rs.shared_cursor (table_text) as text_cursor then
				from list.start until list.after loop
					start_index := list.item_lower; end_index := list.item_upper
					line_count := end_index - start_index + 1
					if line_count >= 2 and then table_text [start_index] /= '%T' and then table_text [end_index] = ':'
						and then not text_cursor.has_character_in_bounds (' ', start_index, end_index - 1)
					then
						if value_end_index > 0 then
							extend (key_interval, ir.compact (value_start_index, value_end_index))
						end
						key_interval := ir.compact (start_index, end_index - 1)
						value_end_index := 0

					elseif line_count > 0 and then table_text [start_index] = '%T' then
						if value_end_index = 0 then
							value_start_index := start_index
						end
						value_end_index := end_index
					end
					list.forth
				end
			end
			if value_end_index > 0 then
				extend (key_interval, ir.compact (value_start_index, value_end_index))
			end
			trim
		end

end