note
	description: "[
		Radio buttons mapped to [$source FINITE [ZSTRING]] list. The displayed strings can be optionally localized.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-09 10:58:09 GMT (Tuesday 9th March 2021)"
	revision: "5"

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