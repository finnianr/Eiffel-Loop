note
	description: "Window that responds to keyboard acceleration keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-16 17:58:35 GMT (Tuesday 16th July 2024)"
	revision: "2"

deferred class
	EL_KEYBOARD_ACCELERATED

inherit
	EL_KEY_ROUTINES

feature {NONE} -- Initialization

	initialize_accelerators
		do
			across new_accelerator_table (Key) as table loop
				add_accelerator_action (table.key, table.item)
			end
		end

feature {NONE} -- Implementation

	add_accelerator_action (modified_code: NATURAL; action: PROCEDURE)
		do
			accelerators.extend (create {EL_ACCELERATOR}.make_with_action (modified_code, action))
		end

	default_accelerator_table (ev: EV_KEY_CONSTANTS): EL_HASH_TABLE [PROCEDURE, like combined]
		-- table of key codes and left-shifted modifiers mapped to procedures
		-- using `single' or `combination' to create key
		do
			create Result
		end

feature {NONE} -- Deferred

	accelerators: EV_ACCELERATOR_LIST
		deferred
		end

	new_accelerator_table (ev: EV_KEY_CONSTANTS): like default_accelerator_table
		-- table of key codes and left-shifted modifiers mapped to procedures
		-- using `single' or `combination' to create key
		deferred
		end

end