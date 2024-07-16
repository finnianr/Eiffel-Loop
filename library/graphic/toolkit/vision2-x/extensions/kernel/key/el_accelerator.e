note
	description: "Keyboard accelerator that can be initialized from type ${EL_KEY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-16 17:57:32 GMT (Tuesday 16th July 2024)"
	revision: "1"

class
	EL_ACCELERATOR

inherit
	EV_ACCELERATOR

create
	default_create, make_with_key_combination, make_with_action

feature {NONE} -- Initialization

	make_with_action (a_key: EL_KEY; action: PROCEDURE)
		do
			make_with_key_combination (a_key, a_key.require_control, a_key.require_alt, a_key.require_shift)
			actions.extend (action)
		end
end