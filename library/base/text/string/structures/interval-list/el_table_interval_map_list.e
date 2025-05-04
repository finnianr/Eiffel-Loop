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
	date: "2025-05-04 6:38:34 GMT (Sunday 4th May 2025)"
	revision: "6"

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
			sg: EL_STRING_GENERAL_ROUTINES
		do
			create list.make (table_text, '%N')
			make_sized (list.count)
			if attached sg.super_readable_general (table_text) as super_table_text then
				from list.start until list.after loop
					start_index := list.item_lower; end_index := list.item_upper
					line_count := end_index - start_index + 1
					if line_count >= 2 and then table_text [start_index] /= '%T' and then table_text [end_index] = ':'
						and then not super_table_text.has_in_bounds (' ', start_index, end_index - 1)
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