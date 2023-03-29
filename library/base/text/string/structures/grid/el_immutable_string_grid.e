note
	description: "[
		2 dimensional array of immutable strings that share the same text of a
		comma separated manifest constant conforming to [$source STRING_GENERAL]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-29 10:30:25 GMT (Wednesday 29th March 2023)"
	revision: "1"

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

	height: INTEGER
		do
			Result := cell_count // width
		end

	width: INTEGER

	cell_count: INTEGER
		deferred
		end

feature {NONE} -- Implementation

	i_th (i: INTEGER): IMMUTABLE_STRING_GENERAL
		deferred
		end

end