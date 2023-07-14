note
	description: "[
		2 dimensional array of immutable strings that share the same text of a
		comma separated manifest constant conforming to [$source STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-14 16:06:29 GMT (Friday 14th July 2023)"
	revision: "3"

deferred class
	EL_IMMUTABLE_STRING_GRID [S -> STRING_GENERAL]

feature {NONE} -- Initialization

	make (a_width: INTEGER; str: S)
		require
			cell_count_divisible_by_width: (str.occurrences (',') + 1) \\ a_width = 0
		do
			width := a_width
			make_shared_adjusted (str, ',', {EL_SIDE}.Left)
		ensure
			cell_count_divisible_by_width: cell_count \\ width = 0
		end

	make_shared_adjusted (str: S; delimiter: CHARACTER_32; a_adjustments: INTEGER)
		deferred
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

	cell_count: INTEGER
		deferred
		end

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

	i_th (i: INTEGER): IMMUTABLE_STRING_GENERAL
		deferred
		end

	target: IMMUTABLE_STRING_GENERAL
		deferred
		end

	new_table: HASH_TABLE [like i_th, like i_th]
		deferred
		end
end