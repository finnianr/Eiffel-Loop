note
	description: "[
		Slicing of a ${SPECIAL [G]} array using base zero modulo indexing so that `item (0, 1)' is
		a special array containing the first two items and `item (-2, -1)' is the last two regardless
		of how many items there are.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-30 17:31:02 GMT (Monday 30th September 2024)"
	revision: "1"

class
	EL_SLICEABLE_SPECIAL [G]

create
	make

feature {NONE} -- Initialization

	make (a_area: like area; a_count: INTEGER)
		require
			valid_count: a_area.valid_index (a_count - 1)
		do
			area := a_area; count := a_count
		end

feature -- Measurement

	count: INTEGER

feature -- Access

	item alias "[]" (start_index, end_index: INTEGER): SPECIAL [G]
		require
			valid_indices (start_index, end_index)
		local
			start_i, end_i, slice_count: INTEGER
		do
			start_i := modulo_index (start_index); end_i := modulo_index (end_index)
			slice_count := end_i - start_i + 1
			create Result.make_empty (slice_count)
			Result.copy_data (area, start_i, 0, slice_count)
		end

feature -- Status query

	valid_indices (start_index, end_index: INTEGER): BOOLEAN
		do
			Result := modulo_index (start_index) - 1 <= modulo_index (end_index)
		end

feature {NONE} -- Implementation

	modulo_index (i: INTEGER): INTEGER
		do
			Result := i \\ count
			if Result < 0 then
				Result := count + i
			end
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [G]
end