note
	description: "Keyboard button press routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-16 17:51:07 GMT (Tuesday 16th July 2024)"
	revision: "1"

deferred class
	EL_KEY_ROUTINES

inherit
	EL_KEY_MODIFIER_CONSTANTS
		undefine
			copy, default_create, is_equal
		end

	EL_SHARED_KEY_CONSTANTS

feature {NONE} -- Implementation

	combined (modifiers: NATURAL; key_code: INTEGER): NATURAL
		do
			Result := (modifiers |<< 16) | key_code.to_natural_32
		end

	single (key_code: INTEGER): NATURAL
		do
			Result := combined (0, key_code)
		end

end