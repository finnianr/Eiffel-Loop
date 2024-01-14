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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-14 18:42:47 GMT (Sunday 14th January 2024)"
	revision: "15"

class
	EL_COMMAND_MENU

inherit
	SINGLE_MATH

	EL_MODULE_LIO; EL_MODULE_USER_INPUT

	EL_CHARACTER_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL; a_options: like options; a_row_count: INTEGER)
		do
			create name.make_from_general (a_name); options := a_options; row_count := a_row_count
			create option_number.make (log10 (a_options.count).ceiling)
			max_column_widths := new_max_column_widths
		end

feature -- Access

	name: ZSTRING

	option_key (i: INTEGER): ZSTRING
		require
			valid_option: valid_option (i)
		do
			Result := options [i]
		end

	row_count: INTEGER

feature -- Status query

	valid_option (i: INTEGER): BOOLEAN
		do
			Result := options.valid_index (i)
		end

feature -- Basic operations

	display
		local
			row, column, index: INTEGER
		do
			lio.put_labeled_string ("MENU", name)
			lio.put_new_line
			lio.put_line (User_input.ESC_to_quit)
			lio.put_new_line
			from row := 0 until row > options.count.min (row_count - 1) loop
				from column := 1 until column > (full_column_count + 1) loop
					index := (column - 1) * row_count + row + 1
					if options.valid_index (index) then
						if column > 1 then
							lio.put_string (Space * padding_width (row, column - 1))
						end
						lio.put_labeled_string (option_number.formatted (index), options [index])
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
			column, i, index, width: INTEGER; menu_item: ZSTRING
		do
			create Result.make_filled (0, 1, full_column_count)
			from column := 1 until column > full_column_count loop
				from i := 1 until i > row_count loop
					index := (column - 1) * row_count + i
					menu_item := options [index]
					width := menu_item.count + option_number.width + 2 -- ": "
					if width > Result [column] then
						Result [column] := width
					end
					i := i + 1
				end
				column := column + 1
			end
		end

	padding_width (row, column: INTEGER): INTEGER
		local
			index: INTEGER
		do
			index := (column - 1) * row_count + row + 1
			Result := max_column_widths [column] - options.item (index).count + 1 - option_number.width - 1
		end

feature {NONE} -- Internal attributes

	max_column_widths: like new_max_column_widths

	option_number: FORMAT_INTEGER

	options: ARRAY [ZSTRING]

end