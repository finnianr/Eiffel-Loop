note
	description: "Summary description for {EL_LOCALE_STRING_ITEM_RADIO_BUTTON_GROUP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

class
	EL_LOCALE_STRING_ITEM_RADIO_BUTTON_GROUP

inherit
	EL_RADIO_BUTTON_GROUP [EL_ASTRING]
		rename
			default_sort_order as alphabetical_sort_order
		end

	EL_MODULE_LOCALE

create
	make

feature {NONE} -- Implementation

	displayed_value (string: EL_ASTRING): EL_ASTRING
		do
			Result := Locale * string
		end
end
