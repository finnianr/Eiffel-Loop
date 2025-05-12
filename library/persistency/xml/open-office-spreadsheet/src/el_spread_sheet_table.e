note
	description: "Object representing table in OpenDocument Flat XML format spreadsheet"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-12 7:14:41 GMT (Monday 12th May 2025)"
	revision: "15"

class
	EL_SPREAD_SHEET_TABLE

inherit
	ARRAYED_LIST [EL_SPREAD_SHEET_ROW]
		rename
			make as make_rows,
			item as row,
			first as first_row,
			last as last_row
		end

	EL_OPEN_OFFICE
		undefine
			copy, is_equal
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (table_node: EL_XPATH_NODE_CONTEXT; defined_ranges: EL_ZSTRING_HASH_TABLE [ZSTRING])
			--
		local
			l_column_table: like column_table
		do
			if is_lio_enabled then
				lio.put_labeled_substitution (generator, "make (%"%S%")", [table_node ["table:name"].as_string])
				lio.put_new_line
			end
			name := table_node ["table:name"]
			l_column_table := column_table (defined_ranges)
			if not l_column_table.is_empty then
				columns := l_column_table.key_list
			end
			make_rows (table_node.query ("count (table:table-row)").as_integer)
			if capacity > 0 then
				append_rows (table_node.context_list ("table:table-row"), l_column_table)
			end
			if is_lio_enabled then
				lio.put_labeled_substitution ("Size", "%S rows X %S columns", [count, maximum_column_count])
				lio.put_new_line
			end
		end

feature -- Access

	name: ZSTRING

	columns: EL_ARRAYED_LIST [ZSTRING]

	maximum_column_count: INTEGER
		do
			across Current as l_row loop
				if l_row.item.count > Result then
					Result := l_row.item.count
				end
			end
		end

feature -- Removal

	prune_trailing_blank_rows
			-- prune trailing empty rows
		do
			from finish until before or else not row.is_blank loop
				remove; finish
			end
		end

feature {NONE} -- Implementation

	append_rows (row_list: EL_XPATH_NODE_CONTEXT_LIST; a_column_table: like column_table)
		local
			new_row: EL_SPREAD_SHEET_ROW
			col_count, count_repeated, i: INTEGER
		do
			row_list.start
			if not row_list.after then
				col_count := row_list.context @ "count (table:table-cell)"
				from until row_list.after loop
					if row_list.context.has_attribute (Attribute_number_rows_repeated) then
						count_repeated := row_list.context [Attribute_number_rows_repeated]
						-- Ignore large repeat count occurring at end of every table
						if count_repeated > Maximum_repeat_count then
							count_repeated := 1
						end
					else
						count_repeated := 1
					end
					create new_row.make (row_list.context.context_list (Xpath_table_cell), col_count, a_column_table)
					from i := 1 until i > count_repeated loop
						if i = 1 then
							extend (new_row)
						else
							extend (new_row.deep_twin)
						end
						i := i + 1
					end
					row_list.forth
				end
			end
		end

	column_table (defined_ranges: EL_ZSTRING_HASH_TABLE [ZSTRING]): EL_ZSTRING_HASH_TABLE [INTEGER]
		local
			cell_range_address: EL_SPLIT_ZSTRING_LIST; left_c, right_c: CHARACTER_8
			column: INTEGER
		do
			create Result.make_equal (11)
			create columns.make_empty
			across defined_ranges as range loop
			-- parse: 'IT Jobs'.G1:.G46
				create cell_range_address.make (range.key, '.')
				if attached cell_range_address as list and then list.count = 3 then
					from list.start until list.after loop
						inspect list.index
							when 1 then
								name := list.item_copy
								name.remove_bookends ('%'', '%'')
							when 2 then
								left_c := range.key.item_8 (list.item_lower)
							when 3 then
								right_c := range.key.item_8 (list.item_lower)
						else
						end
						list.forth
					end
					if left_c = right_c then
						column := left_c |-| 'A' + 1
						Result [range.item] := column
					end
				end
			end
		end

feature {NONE} -- Constants

	Xpath_table_cell: STRING_32 = "table:table-cell"

	Attribute_number_rows_repeated: STRING_32 = "table:number-rows-repeated"

	Maximum_repeat_count: INTEGER
		once
			Result := 1000
		end
end