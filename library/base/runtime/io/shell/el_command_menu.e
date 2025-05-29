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
	date: "2025-05-28 12:43:40 GMT (Wednesday 28th May 2025)"
	revision: "19"

class
	EL_COMMAND_MENU

inherit
	ANY

	EL_MODULE_LIO; EL_MODULE_USER_INPUT

	EL_CHARACTER_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL; a_options: like options; a_row_count: INTEGER)
		local
			 math: EL_INTEGER_MATH
		do
			create name.make_from_general (a_name); options := a_options
			row_count := a_row_count.min (a_options.count)
			column_count := a_options.count // row_count
			if a_options.count \\ row_count > 0 then
				column_count := column_count + 1
			end
			create option_number.make (math.digit_count (a_options.count))
			create max_column_widths.make_filled (0, 1, column_count)
			fill_max_column_widths
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
			row, column, index, padding_width: INTEGER
		do
			lio.put_labeled_string ("MENU", name)
			lio.put_new_line
			lio.put_line (User_input.ESC_to_quit)
			lio.put_new_line
			from row := 1 until row > row_count loop
				from column := 1 until column > column_count loop
					index := (column - 1) * row_count + (row - 1) + 1
					if options.valid_index (index) then
						lio.put_labeled_string (option_number.formatted (index), options [index])
						if column < column_count then
							padding_width := max_column_widths [column] - options [index].count + 1 - option_number.width - 1
							lio.put_string (Space * padding_width)
						end
					end
					column := column + 1
				end
				lio.put_new_line
				row := row + 1
			end
			lio.put_new_line
		end

feature {NONE} -- Implementation

	fill_max_column_widths
		local
			column, row, index, width: INTEGER
		do
			from column := 1 until column > column_count loop
				from row := 1 until row > row_count loop
					index := (column - 1) * row_count + (row - 1) + 1
					if options.valid_index (index) then
						width := options [index].count + option_number.width + 2 -- ": "
						if width > max_column_widths [column] then
							max_column_widths [column] := width
						end
					end
					row := row + 1
				end
				column := column + 1
			end
		end

feature {NONE} -- Internal attributes

	column_count: INTEGER
		-- count of columns

	max_column_widths: ARRAY [INTEGER]

	option_number: FORMAT_INTEGER

	options: ARRAY [ZSTRING]

end