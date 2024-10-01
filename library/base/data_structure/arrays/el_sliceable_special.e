note
	description: "[
		Slicing of a ${SPECIAL [G]} array using zero based modulo indexing so that `item (0, 1)' is
		a special array containing the first two items and `item (-2, -1)' the last two.
	]"
	notes: "[
		This is similar to Python slicing except in Python the end index is excluded from the slice.
		So in Python the slice `item [-2, -1]' has to be expressed as `[-2:]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-01 12:28:21 GMT (Tuesday 1st October 2024)"
	revision: "2"

class
	EL_SLICEABLE_SPECIAL [G]

inherit
	EL_MODULO_INDEXABLE

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
		-- sub array of special using zero based modulo indexing
		require
			valid_slice (start_index, end_index)
		local
			start_i, end_i, slice_count: INTEGER
		do
			start_i := modulo_index (start_index); end_i := modulo_index (end_index)
			slice_count := end_i - start_i + 1
			create Result.make_empty (slice_count)
			Result.copy_data (area, start_i, 0, slice_count)
		end

feature {NONE} -- Internal attributes

	area: SPECIAL [G]
end