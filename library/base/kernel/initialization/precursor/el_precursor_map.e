note
	description: "[
		Tracks whether a routine has been called already or not during `make' precursor calls.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_PRECURSOR_MAP

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

	done_bitmap: NATURAL
		-- each bit refers to a make routine

	done_mask (routine: POINTER): NATURAL
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
			no_more_than_32_flag_bits: done_mask_table.count <= {PLATFORM}.Natural_32_bits
		end

	done_mask_table: HASH_TABLE [NATURAL, POINTER]
		-- implement as a once function for each class heirarchy
		deferred
		end
note
	notes: "[
		This class maps each routine address to a single bit in a 32 bit natural.
		Each bit indicates whether the routine has been called already or not. For hierarchies
		with more than 32 members you will need to use class ${EL_PRECURSOR_MAP_64}.
		With 16 or few members you can use ${EL_PRECURSOR_MAP_16}.
		A new bit mask is added to the table for each new routine address.

		**For Eiffel Newbies**

		It is worth reading the source for NATURAL_32_REF to get an understanding of what bit operators are available in Eiffel.
		To understand what's happening in `initialization_mask' read the commented description for `put' in the source for
		HASH_TABLE. This routine has some subtleties that are not obvious.
	]"

end