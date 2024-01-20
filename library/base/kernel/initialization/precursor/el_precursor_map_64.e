note
	description: "[
		Tracks whether a routine has been called already or not during `make' precursor calls.
		This is a variation of class ${EL_PRECURSOR_MAP} but with the `done_bitmap' defined
		as ${NATURAL_64} instead of ${NATURAL_32}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "5"

deferred class
	EL_PRECURSOR_MAP_64

feature {NONE} -- Status query

	done (routine: POINTER): BOOLEAN
		-- `True' if routine with address `routine' has already been called on `Current'
		do
			Result := (done_bitmap & done_mask (routine)).to_boolean
		end

feature {NONE} -- Element change

	set_done (routine: POINTER)
		-- mark routine with address `routine' as being done for `Current'
		do
			done_bitmap := done_bitmap | done_mask (routine)
		end

feature {NONE} -- Implementation

	done_bitmap: NATURAL_64
		-- each bit refers to a make routine

	done_mask (routine: POINTER): NATURAL_64
		local
			table: like done_mask_table
		do
			table := done_mask_table
			if table.is_empty then
				table.put (1, routine)
			else
				table.put (table.found_item |<< 1, routine)
			end
			Result := table.found_item
		ensure
			no_more_than_32_flag_bits: done_mask_table.count <= {PLATFORM}.Natural_64_bits
		end

	done_mask_table: HASH_TABLE [NATURAL_64, POINTER]
		-- implement as a once function for each class heirarchy
		deferred
		end

end