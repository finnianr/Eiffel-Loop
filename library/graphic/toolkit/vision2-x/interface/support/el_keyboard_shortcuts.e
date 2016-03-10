note
	description: "Summary description for {EV_KEYBOARD_SHORTCUTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_KEYBOARD_SHORTCUTS

inherit
	EL_KEY_MODIFIER_CONSTANTS

create
	make, make_from_accelerators

feature {NONE} -- Initialization

	make (a_window: EV_WINDOW)
			--
		do
			make_from_accelerators (a_window.accelerators)
		end

	make_from_accelerators (a_accelerators: like accelerators)
			--
		do
			accelerators := a_accelerators
		end

feature -- Access

	create_accelerator (key_code: INTEGER; modifier_keys: NATURAL): EV_ACCELERATOR
		do
			create Result.make_with_key_combination (
				create {EV_KEY}.make_with_code (key_code),

				(modifier_keys & Modifier_ctrl).to_boolean, 		-- require_control
				(modifier_keys & Modifier_alt).to_boolean, 			-- require_alt
				(modifier_keys & Modifier_shift).to_boolean			-- require_shift
			)
			accelerators.extend (Result)
		end

feature -- Element change

	add_unmodified_key_action (key_code: INTEGER; action: PROCEDURE [ANY, TUPLE])
			--
		do
			add_key_action (key_code, action, Modifier_none)
		end

	add_ctrl_shift_key_action (key_code: INTEGER; action: PROCEDURE [ANY, TUPLE])
			--
		do
			add_key_action (key_code, action, Modifier_ctrl | Modifier_shift)
		end

	add_ctrl_key_action (key_code: INTEGER; action: PROCEDURE [ANY, TUPLE])
			--
		do
			add_key_action (key_code, action, Modifier_ctrl)
		end

	add_alt_key_action (key_code: INTEGER; action: PROCEDURE [ANY, TUPLE])
			--
		do
			add_key_action (key_code, action, Modifier_alt)
		end

	add_key_action (key_code: INTEGER; action: PROCEDURE [ANY, TUPLE]; modifier_keys: NATURAL)
			--
		local
			accelerator: EV_ACCELERATOR
		do
			accelerator := create_accelerator (key_code, modifier_keys)
			accelerator.actions.extend (action)
		end

	accelerators: EV_ACCELERATOR_LIST

end
