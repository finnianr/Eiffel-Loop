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
	date: "2025-10-08 8:34:10 GMT (Wednesday 8th October 2025)"
	revision: "21"

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
			 math: EL_INTEGER_MATH; column_count, row_count: INTEGER
		do
			create name.make_from_general (a_name); options := a_options
			if a_options.count > 0 then
				row_count := a_row_count.min (a_options.count)
				column_count := a_options.count // row_count
				if a_options.count \\ row_count > 0 then
					column_count := column_count + 1
				end
			end
			column_interval := 1 |..| column_count; row_interval := 1 |..| row_count
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

	row_interval: INTEGER_INTERVAL

feature -- Status query

	valid_option (i: INTEGER): BOOLEAN
		do
			Result := options.valid_index (i)
		end

feature -- Basic operations

	display
		local
			index, padding_width: INTEGER
		do
			lio.put_labeled_string ("MENU", name)
			lio.put_new_line
			lio.put_line (User_input.ESC_to_quit)
			lio.put_new_line
			across row_interval as row loop
				across column_interval as column loop
					index := option_index (column.item, row.item)
					if options.valid_index (index) then
						lio.put_labeled_string (option_number.formatted (index), options [index])
						if column_interval.has (column.item) then
							padding_width := max_column_widths [column.item] - options [index].count + 1 - option_number.width - 1
							lio.put_string (Space * padding_width)
						end
					end
				end
				lio.put_new_line
			end
			lio.put_new_line
		end

feature {NONE} -- Implementation

	fill_max_column_widths
		local
			index, width: INTEGER
		do
			across column_interval as column loop
				across row_interval as row loop
					index := option_index (column.item, row.item)
					if options.valid_index (index) then
						width := options [index].count + option_number.width + 2 -- ": "
						if width > max_column_widths [column.item] then
							max_column_widths [column.item] := width
						end
					end
				end
			end
		end

	option_index (column, row: INTEGER): INTEGER
		do
			Result := (column - 1) * row_interval.upper + row
		end

feature {NONE} -- Internal attributes

	column_interval: INTEGER_INTERVAL

	max_column_widths: ARRAY [INTEGER]

	option_number: FORMAT_INTEGER

	options: ARRAY [ZSTRING]

end