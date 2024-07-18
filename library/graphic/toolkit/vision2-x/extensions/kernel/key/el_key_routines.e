note
	description: "Keyboard button press routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 7:35:15 GMT (Thursday 18th July 2024)"
	revision: "2"

deferred class
	EL_KEY_ROUTINES

inherit
	EL_KEY_MODIFIER_CONSTANTS
		undefine
			copy, default_create, is_equal
		end

	EL_SHARED_KEY_CONSTANTS

feature {NONE} -- Implementation

	combined (modifier_code: NATURAL; key_code: INTEGER): NATURAL
		-- `key_code' combined with `modifier_code' which in turn is
		-- `Alt', `Ctrl', `Shift' combined with OR operator
		do
			Result := (modifier_code |<< 16) | key_code.to_natural_32
		end

	single (key_code: INTEGER): NATURAL
		do
			Result := combined (0, key_code)
		end

end