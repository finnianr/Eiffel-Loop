note
	description: "Window that responds to keyboard acceleration keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-28 15:36:04 GMT (Sunday 28th January 2024)"
	revision: "1"

deferred class
	EL_KEYBOARD_ACCELERATED

inherit
	EL_KEY_MODIFIER_CONSTANTS
		undefine
			copy, default_create, is_equal
		end

	EL_SHARED_KEY_CONSTANTS

feature {NONE} -- Initialization

	initialize_accelerators
		do
			across new_accelerator_table (Key) as table loop
				add_accelerator_action (table.key, table.item)
			end
		end

feature {NONE} -- Implementation

	add_accelerator_action (combined_code: NATURAL; action: PROCEDURE)
		local
			key_code: NATURAL_16; modifiers: NATURAL; item: EV_ACCELERATOR
			require_control, require_alt, require_shift: BOOLEAN
			l_key: EV_KEY
		do
			key_code := combined_code.to_natural_16; modifiers := combined_code |>> 16

			create l_key.make_with_code (key_code.to_integer_32)
			require_control := (modifiers & Ctrl).to_boolean
			require_alt := (modifiers & Alt).to_boolean
			require_shift := (modifiers & Shift).to_boolean

			create item.make_with_key_combination (l_key, require_control, require_alt, require_shift)
			item.actions.extend (action)
			accelerators.extend (item)
		end

	combined (modifiers: NATURAL; key_code: INTEGER): NATURAL
		do
			Result := (modifiers |<< 16) | key_code.to_natural_32
		end

	default_accelerator_table (ev: EV_KEY_CONSTANTS): EL_HASH_TABLE [PROCEDURE, like combined]
		-- table of key codes and left-shifted modifiers mapped to procedures
		-- using `single' or `combination' to create key
		do
			create Result
		end

	single (key_code: INTEGER): NATURAL
		do
			Result := combined (0, key_code)
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