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
	date: "2020-01-29 9:45:06 GMT (Wednesday 29th January 2020)"
	revision: "7"

deferred class
	EL_INITIALIZEABLE

feature {NONE} -- Initialization

	make
		deferred
		ensure
			stack_unchanged: old Type_stack.count = Type_stack.count
		end

feature {NONE} -- Status query

	not_initialized (type: TYPE [EL_INITIALIZEABLE]): BOOLEAN
		do
			Result := not_initialized_for_id (type.type_id)
		end

	not_initialized_for_id (type_id: INTEGER): BOOLEAN
		require

		do
			Type_stack.put (type_id)
			Result := not (initialization_bitmap & initialization_mask).to_boolean
		end

feature {NONE} -- Element change

	set_initialized
		do
			initialization_bitmap := initialization_bitmap | initialization_mask
			Type_stack.remove
		end

feature {NONE} -- Implementation

	initialization_bitmap: NATURAL
		-- each bit refers to a class in a heirarchy

	initialization_mask: NATURAL
		require
			valid_stack: not Type_stack.is_empty
		local
			table: like Initialization_mask_table
		do
			table := Initialization_mask_table
			if table.is_empty then
				table.put (1, Type_stack.item)
			else
				table.put (table.found_item |<< 1, Type_stack.item)
			end
			Result := table.found_item
		ensure
			no_more_than_32_flag_bits: Initialization_mask_table.count <= {PLATFORM}.Natural_32_bits
		end

	initialization_mask_table: HASH_TABLE [NATURAL, INTEGER]
		-- implement as a once function for each class heirarchy
		deferred
		end

feature {NONE} -- Constants

	Type_stack: ARRAYED_STACK [INTEGER]
		once
			create Result.make (7)
		end

end
