note
	description: "SmartEiffel compatible 2 dimensional array"

	author: "Finnian Reilly"
	copyright: "[
	Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly
	]"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:47:36 GMT (Tuesday 8th February 2022)"
	revision: "2"

class
	SE_ARRAY2 [G]

inherit

	ARRAY [G]
		rename
			make as array_make,
			item as array_item,
			put as array_put,
			force as array_force,
			resize as array_resize,
			wipe_out as array_wipe_out,
			make_filled as array_make_filled
		export
			{NONE} array_make, array_force, array_resize, array_wipe_out, make_from_array, array_make_filled, make_from_special, make_from_cil, remove_head, remove_tail, keep_head, keep_tail, grow, conservative_resize, conservative_resize_with_default, automatic_grow
			{SE_ARRAY2} array_put, array_item
			{ANY} copy, is_equal, area, to_c
		end

create
	make, make_filled, make_row_columns

feature -- Initialization

	make (row_min, row_max, column_min, column_max: INTEGER)
		do
			make_row_columns (row_max - row_min + 1, column_max - column_min + 1)
			row_offset := row_min - 1
			column_offset := column_min - 1
			height := row_max - row_min + 1
			width := column_max - column_min + 1
		end

	make_row_columns (nb_rows, nb_columns: INTEGER)
			-- Create a two dimensional array which has `nb_rows'
			-- rows and `nb_columns' columns,
			-- with lower bounds starting at 1.
		obsolete
			"`make' is not void-safe statically. Use `make_filled' instead. [07-2010]"
		require
			nb_rows_non_negative: nb_rows >= 0
			nb_columns_non_negative: nb_columns >= 0
			both_zero_or_both_non_zero: not (nb_rows = 0 xor nb_columns = 0)
			has_default: (nb_rows * nb_columns) /= 0 implies ({G}).has_default
		do
			height := nb_rows
			width := nb_columns
			array_make (1, nb_rows * nb_columns)
		ensure
			new_count: count = height * width
		end

	make_filled (a_default_value: G; nb_rows, nb_columns: INTEGER)
			-- Create a two dimensional array which has `nb_rows'
			-- rows and `nb_columns' columns,
			-- with lower bounds starting at 1 filled with value `a_default_value'.
		require
			nb_rows_non_negative: nb_rows >= 0
			nb_columns_non_negative: nb_columns >= 0
			both_zero_or_both_non_zero: not (nb_rows = 0 xor nb_columns = 0)
		do
			height := nb_rows
			width := nb_columns
			array_make_filled (a_default_value, 1, nb_rows * nb_columns)
		ensure
			new_count: count = height * width
			filled: filled_with (a_default_value)
		end

	initialize (v: G)
			-- Make each entry have value `v'.
		do
			fill_with (v)
		end

	set_height (v: INTEGER)
			-- Set value of height to `v'.
		do
			height := v
		end

	set_width (v: INTEGER)
			-- Set value of width to `v'.
		do
			width := v
		end

	set_column_offset (v: INTEGER)
			-- Set value of column_offset to `v'.
		do
			column_offset := v
		end

	set_row_offset (v: INTEGER)
			-- Set value of row_offset to `v'.
		do
			row_offset := v
		end

feature -- Access

	item alias "[]" (row, column: INTEGER): G assign put
			-- Entry at coordinates (`row', `column')
		require
			valid_row: (1 <= row - row_offset) and (row - row_offset <= height)
			valid_column: (1 <= column - column_offset) and (column - column_offset <= width)
		do
			Result := array_item ((row - row_offset - 1) * width + (column - column_offset))
		end

feature -- Measurement

	height: INTEGER assign set_height
			-- Number of rows

	width: INTEGER assign set_width
			-- Number of columns

	column_offset: INTEGER assign set_column_offset

	row_offset: INTEGER assign set_row_offset

feature -- Element change

	put (v: like item; row, column: INTEGER)
			-- Assign item `v' at coordinates (`row', `column').
		require
			valid_row: 1 <= row - row_offset and row - row_offset <= height
			valid_column: 1 <= column - column_offset and column - column_offset <= width
		do
			array_put (v, (row - row_offset - 1) * width + (column - column_offset))
		end

	force (v: like item; row, column: INTEGER)
			-- Assign item `v' at coordinates (`row', `column').
			-- Resize if necessary.
		require
			row_large_enough: 1 <= row - row_offset
			column_large_enough: 1 <= column - column_offset
			has_default: ({G}).has_default
		do
			resize_with_default (({G}).default, row - row_offset, column - column_offset)
			put (v, row - row_offset, column - column_offset)
		end

feature -- Removal

	wipe_out
			-- Remove all items.
		do
			height := 0
			width := 0
			make_empty
		end

feature -- Resizing

	resize (nb_rows, nb_columns: INTEGER)
			-- Rearrange array so that it can accommodate
			-- `nb_rows' rows and `nb_columns' columns,
			-- without losing any previously
			-- entered items, nor changing their coordinates;
			-- do nothing if new values are smaller.
		obsolete
			"`resize' is not void-safe statically. Use `resize_with_default' instead. [07-2010]"
		require
			valid_row: nb_rows >= 1
			valid_column: nb_columns >= 1
			has_default: ({G}).has_default
		do
			if (nb_columns > width) or (nb_rows > height) then
				resize_with_default (({G}).default, nb_rows, nb_columns)
			end
		ensure
			no_smaller_height: height >= old height
			no_smaller_width: width >= old width
		end

	resize_with_default (a_default: G; nb_rows, nb_columns: INTEGER)
			-- Rearrange array so that it can accommodate
			-- `nb_rows' rows and `nb_columns' columns,
			-- without losing any previously
			-- entered items, nor changing their coordinates;
			-- do nothing if new values are smaller.
		require
			valid_row: nb_rows >= 1
			valid_column: nb_columns >= 1
		local
			i: INTEGER
			new_height: like height
			previous_width: like width
		do
			if nb_columns > width then
					-- Both rows and columns have been added. We resize `area' to the requested size.
				new_height := nb_rows.max (height)
				previous_width := width
				conservative_resize_with_default (a_default, 1, new_height * nb_columns)

					-- Go through all rows and shift items at their right place in the resized `area'.
				from
					i := height
				until
					i = 0
				loop
					area.move_data ((i - 1) * previous_width, (i - 1) * nb_columns, previous_width)
					area.fill_with (a_default, (i - 1) * nb_columns + previous_width, i * nb_columns - 1)
					i := i - 1
				end
				width := nb_columns
				height := new_height
			elseif nb_rows > height then
					-- Only a new row was added, we simply extend `area' by that many new rows.
				conservative_resize_with_default (a_default, 1, nb_rows * width)
				height := nb_rows
			end
		ensure
			no_smaller_height: height >= old height
			no_smaller_width: width >= old width
		end

invariant
	items_number: count = width * height

end