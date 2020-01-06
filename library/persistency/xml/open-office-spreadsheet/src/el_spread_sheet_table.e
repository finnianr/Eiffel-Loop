note
	description: "Object representing table in OpenDocument Flat XML format spreadsheet"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:37:46 GMT (Monday 1st July 2019)"
	revision: "4"

class
	EL_SPREAD_SHEET_TABLE

inherit
	ARRAYED_LIST [EL_SPREAD_SHEET_ROW]
		rename
			make as make_array,
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
			table_rows: EL_XPATH_NODE_CONTEXT_LIST
			new_row: EL_SPREAD_SHEET_ROW
			number_of_columns, count_repeated, i: INTEGER
			l_column_table: like column_table
		do
			if is_lio_enabled then
				lio.put_substitution ("make_from_table_context (%S)", [table_node.attributes ["table:name"]])
				lio.put_new_line
			end
			name := table_node.attributes ["table:name"]
			l_column_table := column_table (defined_ranges)
			if not l_column_table.is_empty then
				columns := l_column_table.current_keys
			end

			number_of_columns := table_node.integer_at_xpath ("table:table-row[1]/table:table-cell[1]/@table:number-columns-spanned")
			if number_of_columns = 0 then
				number_of_columns := Default_number_of_columns
			end

			table_rows := table_node.context_list ("table:table-row")
			make_array (table_rows.count)
			if is_lio_enabled then
				lio.put_integer_field ("capacity", capacity); lio.put_new_line
			end
			from table_rows.start until table_rows.after loop
				if is_lio_enabled then
					lio.put_integer_field ("Reading row", table_rows.index); lio.put_new_line
				end
				if table_rows.context.attributes.has (Attribute_number_rows_repeated) then
					count_repeated := table_rows.context.attributes.integer (Attribute_number_rows_repeated)
					-- Ignore large repeat count occurring at end of every table
					if count_repeated > Maximum_repeat_count then
						count_repeated := 1
					end
				else
					count_repeated := 1
				end
				create new_row.make (
					table_rows.context.context_list (Xpath_table_cell), number_of_columns, l_column_table
				)
				from i := 1 until i > count_repeated loop
					if i = 1 then
						extend (new_row)
					else
						extend (new_row.deep_twin)
					end
					i := i + 1
				end
				table_rows.forth
			end
			if is_lio_enabled then
				lio.put_integer_field ("Table column count", number_of_columns)
				lio.put_new_line
				lio.put_integer_field ("Table row count", count)
				lio.put_new_line
				lio.put_new_line
			end
		end

feature -- Access

	name: ZSTRING

	columns: ARRAY [ZSTRING]

feature -- Removal

	prune_trailing_blank_rows
			-- prune trailing empty rows
		do
			if is_lio_enabled then
				lio.put_line ("Removing trailing blank rows")
			end
			from finish until before or else not row.is_blank loop
				remove; finish
			end
		end

feature {NONE} -- Implementation

	column_table (defined_ranges: EL_ZSTRING_HASH_TABLE [ZSTRING]): EL_ZSTRING_HASH_TABLE [INTEGER]

		local
			cell_range_address: EL_ZSTRING_LIST
			column_interval: INTEGER_INTERVAL
		do
			create Result.make_equal (11)
			create columns.make_empty
			across defined_ranges as range loop
				create cell_range_address.make_with_separator (range.key, '.', True)
				cell_range_address.first.remove_quotes
				if cell_range_address.first ~ name then
					create column_interval.make (
						cell_range_address.i_th (2).z_code (1).to_integer_32 - 64,
						cell_range_address.i_th (3).z_code (1).to_integer_32 - 64
					)
					if column_interval.count = 1 then
						Result [range.item] := column_interval.lower
					end
				end
			end
		end

feature {NONE} -- Constants

	Xpath_table_cell: STRING_32 = "table:table-cell"

	Attribute_number_rows_repeated: STRING_32 = "table:number-rows-repeated"

	Default_number_of_columns: INTEGER
		once
			Result := 10
		end

	Maximum_repeat_count: INTEGER
		once
			Result := 1000
		end
end
