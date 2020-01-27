note
	description: "[
		Initializeable object to prevent repeated calls to same routine during `make' precursor calls
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-27 19:15:11 GMT (Monday 27th January 2020)"
	revision: "6"

deferred class
	EL_INITIALIZEABLE

feature {NONE} -- Initialization

	make
		deferred
		ensure
			initialized: is_initialized
			stack_unchanged: old Type_stack.count = Type_stack.count
		end

feature {NONE} -- Status query

	not_initialized (type: TYPE [ANY]): BOOLEAN
		do
			Type_stack.put (type)
			Result := not is_initialized
		end

	is_initialized: BOOLEAN
		-- `True' if current type is initialized
		do
			Result := (initialization_bitmap & initialization_mask).to_boolean
		end

feature {NONE} -- Element change

	set_initialized
		do
			initialization_bitmap := initialization_bitmap | initialization_mask
			Type_stack.remove
		end

feature {NONE} -- Implementation

	initialization_mask: NATURAL
		local
			table: like Initialization_mask_table
			type_id: INTEGER
		do
			type_id := Type_stack.item.type_id
			if table.is_empty then
				table.put (1, type_id)
			else
				table.put (table.found_item |<< 1, type_id)
			end
			Result := table.found_item
		ensure
			no_more_than_32_flag_bits: Initialization_mask_table.count <= {PLATFORM}.Natural_32_bits
		end

	initialization_mask_table: HASH_TABLE [NATURAL, INTEGER]
		-- implement as a once function for each class heirarchy
		deferred
		end

	initialization_bitmap: NATURAL
		-- each bit refers to a class in a heirarchy

feature {NONE} -- Constants

	Type_stack: ARRAYED_STACK [TYPE [ANY]]
		once
			create Result.make (7)
		end

end
