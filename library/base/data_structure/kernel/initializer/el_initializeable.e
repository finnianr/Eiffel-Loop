note
	description: "Initializeable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-27 16:41:43 GMT (Monday 27th January 2020)"
	revision: "5"

deferred class
	EL_INITIALIZEABLE

feature {NONE} -- Initialization

	make
		deferred
		ensure
			initialized: is_initialized
		end

feature {NONE} -- Status query

	not_initialized: BOOLEAN
		do
			Result := not is_initialized
		end

	is_initialized: BOOLEAN
		-- `True' if current type is initialized
		do
			Result := (initialization_flags & Initialization_mask).to_boolean
		end

feature {NONE} -- Element change

	set_initialized
		do
			initialization_flags := initialization_flags | Initialization_mask
		end

feature {NONE} -- Implementation

	initialization_mask: NATURAL
		local
			table: like Initialization_mask_table
			type_id: INTEGER
		do
			type_id := {ISE_RUNTIME}.dynamic_type (Current)
			if table.is_empty then
				table.put (1, type_id)
			else
				table.put (table.found_item |<< 1, type_id)
			end
			Result := table.found_item
		ensure
			no_more_than_32_flag_bits: Initialization_mask_table.count <= {PLATFORM}.Natural_32_bits
		end

	initialization_flags: NATURAL

feature {NONE} -- Constants

	Initialization_mask_table: HASH_TABLE [NATURAL, INTEGER]
		deferred
		end

end
