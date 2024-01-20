note
	description: "[
		2 dimensional array of immutable strings that share the same text of a
		comma separated manifest constant conforming to ${STRING_GENERAL}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "6"

deferred class
	EL_IMMUTABLE_STRING_GRID [GENERAL -> STRING_GENERAL, IMMUTABLE -> IMMUTABLE_STRING_GENERAL create make end]

inherit
	EL_SPLIT_READABLE_STRING_LIST [IMMUTABLE]
		rename
			make as make_split,
			count as cell_count
		export
			{NONE} all
			{ANY} cell_count
		end

	EL_STRING_BIT_COUNTABLE [IMMUTABLE]

feature {NONE} -- Initialization

	make (a_width: INTEGER; str: GENERAL)
		require
			cell_count_divisible_by_width: (str.occurrences (',') + 1) \\ a_width = 0
		do
			width := a_width
			make_empty
			if attached new_split_list (str) as list then
				area := list.area
				target_string := list.target_string
			end
		ensure
			cell_count_divisible_by_width: cell_count \\ width = 0
		end

feature -- Access

	i_th_cell (i, column: INTEGER): like i_th
		require
			valid_index: 1 <= i and i <= height
			valid_column: 1 <= column and column <= width
		local
			j: INTEGER
		do
			j := (i - 1) * width + column
			Result := i_th (j)
		end

feature -- Measurement

	height: INTEGER
		do
			Result := cell_count // width
		end

	width: INTEGER

feature -- Conversion

	to_table (key_column: INTEGER): like new_table
		require
			two_columns: width = 2
			valid_key_column: key_column = 1 or key_column = 2
		local
			row, l_height, item_column: INTEGER
		do
			Result := new_table
			if key_column = 1 then
				item_column := 2
			else
				item_column := 1
			end
			l_height := height
			from row := 1 until row > l_height loop
				Result.extend (i_th_cell (row, item_column), i_th_cell (row, key_column))
				row := row + 1
			end
		end

feature {EL_IMMUTABLE_STRING_TABLE} -- Implementation

	new_split_list (str: GENERAL): EL_SPLIT_IMMUTABLE_STRING_LIST [GENERAL, IMMUTABLE]
		deferred
		end

	new_table: HASH_TABLE [like i_th, like i_th]
		deferred
		end

end