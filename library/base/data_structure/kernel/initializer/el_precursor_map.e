note
	description: "[
		Initializeable object to prevent repeated calls to same routine during `make' precursor calls
	]"
	notes: "[
		This class maps each initialize-able type to a single bit in a 32 bit natural.
		Each bit represents the initialization status of one of 32 different types. For hierarchies
		with more than this you will need to make a similar class using a NATURAL_64.
		A new bit mask is added for each new type.

		**For Eiffel Newbies**

		It is worth reading the source for NATURAL_32_REF to get an understanding of what bit operators are available in Eiffel.
		To understand what's happening in `initialization_mask' read the commented description for `put' in the source for
		HASH_TABLE. This routine has some subtleties that are not obvious.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 9:49:30 GMT (Wednesday 29th January 2020)"
	revision: "1"

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

end
