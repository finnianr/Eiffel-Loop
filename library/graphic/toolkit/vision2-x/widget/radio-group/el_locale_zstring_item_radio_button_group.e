note
	description: "[
		Radio buttons mapped to ${FINITE [ZSTRING]} list. The displayed strings can be optionally localized.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_LOCALE_ZSTRING_ITEM_RADIO_BUTTON_GROUP

inherit
	EL_RADIO_BUTTON_GROUP [ZSTRING]
		rename
			less_than as alphabetical_less_than
		end

	EL_MODULE_DEFERRED_LOCALE

create
	make

feature {NONE} -- Implementation

	displayed_value (string: ZSTRING): ZSTRING
		do
			Result := Locale * string
		end
end