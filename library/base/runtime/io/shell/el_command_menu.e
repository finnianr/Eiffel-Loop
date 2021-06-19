note
	description: "[
		Displays a console menu in columns each with a maximum of 10 options.
		The columns are padded to use the minimum amount of horizontal character space.
		
		**Example:**
		
			SELECT MENU OPTION
			0: Shutdown service             10: List failed payments
			1: Create versioned backup      11: List feature requests
			2: Delete customer              12: List online resource requests
			3: Delete database              13: List payments
			4: Delete customer subscription 14: Reassign current subscription
			5: Fix the database             15: Test license management
			6: Forward subscription pack    16: Verify key pair
			7: Import Pyxis customer data   17: View log output for service
			8: List customers
			9: List customer subscriptions

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-19 8:59:47 GMT (Saturday 19th June 2021)"
	revision: "9"

class
	EL_COMMAND_MENU

inherit
	SINGLE_MATH

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL; a_options: like options; a_row_count: INTEGER)
		do
			create name.make_from_general (a_name); options := a_options; row_count := a_row_count
			max_column_widths := new_max_column_widths
			create option_number.make (log10 (a_options.count).ceiling)
		end

feature -- Access

	name: ZSTRING

	option_key (n: INTEGER): ZSTRING
		require
			valid_option: valid_option (n)
		do
			Result := options [n + 1]
		end

	row_count: INTEGER

feature -- Status query

	valid_option (n: INTEGER): BOOLEAN
		do
			Result := options.valid_index (n + 1)
		end

feature -- Basic operations

	display
		local
			row, column, index: INTEGER
		do
			lio.put_labeled_string ("MENU", name)
			lio.put_new_line_x2
			from row := 0 until row > options.count.min (row_count - 1) loop
				from column := 1 until column > (full_column_count + 1) loop
					index := (column - 1) * row_count + row + 1
					if options.valid_index (index) then
						if column > 1 then
							lio.put_string (padding (row, column - 1))
						end
						lio.put_labeled_string (option_number.formatted (index - 1), options [index])
					end
					column := column + 1
				end
				lio.put_new_line
				row := row + 1
			end
			lio.put_new_line
		end

feature {NONE} -- Implementation

	full_column_count: INTEGER
			-- count of columns that are full
		do
			Result := options.count // row_count
		end

	new_max_column_widths: ARRAY [INTEGER]
		local
			column, i, index: INTEGER; menu_item: ZSTRING
		do
			create Result.make_filled (0, 1, full_column_count)
			from column := 1 until column > full_column_count loop
				from i := 1 until i > row_count loop
					index := (column - 1) * row_count + i
					menu_item := options [index]
					if menu_item.count > Result [column] then
						Result [column] := menu_item.count
					end
					i := i + 1
				end
				column := column + 1
			end
		end

	padding (row, column: INTEGER): STRING
		local
			index: INTEGER
		do
			index := (column - 1) * row_count + row + 1
			create Result.make_filled (' ', max_column_widths [column] - options.item (index).count + 1)
		end

feature {NONE} -- Internal attributes

	max_column_widths: like new_max_column_widths

	option_number: FORMAT_INTEGER

	options: ARRAY [ZSTRING]

end