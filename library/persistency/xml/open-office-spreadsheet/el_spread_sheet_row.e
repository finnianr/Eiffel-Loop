note
	description: "[
		Object representing table row in OpenDocument Flat XML format spreadsheet
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:37:19 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_SPREAD_SHEET_ROW

inherit
	ARRAYED_LIST [EL_SPREAD_SHEET_DATA_CELL]
		rename
			make as make_array,
			item as cell_item,
			first as first_cell,
			last as last_cell
		end

	EL_OPEN_OFFICE
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (table_row_node_list: EL_XPATH_NODE_CONTEXT_LIST; number_of_columns: INTEGER; a_columns: like columns)
			--
		local
			data_cell: EL_SPREAD_SHEET_DATA_CELL
			i, number_columns_repeated: INTEGER
		do
			make_array (number_of_columns)
			columns := a_columns
			from table_row_node_list.start until full or table_row_node_list.after loop
				if table_row_node_list.context.attributes.has (Attribute_number_columns_repeated) then
					number_columns_repeated := table_row_node_list.context.attributes.integer (Attribute_number_columns_repeated)
				else
					number_columns_repeated := 1
				end
				create data_cell.make_from_context (table_row_node_list.context)
				from i := 1 until full or i > number_columns_repeated loop
					if i = 1 then
						extend (data_cell)
					else
						extend (data_cell.twin)
					end
					i := i + 1
				end
				table_row_node_list.forth
			end
			from until full loop
				extend (Empty_cell)
			end
		end

feature -- Access

	cell (name: ZSTRING): EL_SPREAD_SHEET_DATA_CELL
		do
			columns.search (name)
			if columns.found then
				Result := i_th (columns.found_item)
			else
				create Result.make_empty
			end
		end

feature -- Status report

	is_blank: BOOLEAN
			--
		do
			Result := for_all (agent {EL_SPREAD_SHEET_DATA_CELL}.is_empty)
		end

feature {NONE} -- Implementation

	columns: EL_ZSTRING_HASH_TABLE [INTEGER]

feature {NONE} -- Constants

	Attribute_number_columns_repeated: STRING_32 = "table:number-columns-repeated"

	Empty_cell: EL_SPREAD_SHEET_DATA_CELL
			--
		once
			create Result.make_empty
		end

end