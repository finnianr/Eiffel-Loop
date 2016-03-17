note
	description: "Summary description for {EL_LOCALE_STRING_ITEM_RADIO_BUTTON_GROUP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-04 9:58:06 GMT (Monday 4th January 2016)"
	revision: "6"

class
	EL_LOCALE_STRING_ITEM_RADIO_BUTTON_GROUP

inherit
	EL_RADIO_BUTTON_GROUP [ZSTRING]
		rename
			default_sort_order as alphabetical_sort_order
		end

	EL_MODULE_LOCALE

create
	make

feature {NONE} -- Implementation

	displayed_value (string: ZSTRING): ZSTRING
		do
			Result := Locale * string
		end
end
