note
	description: "Summary description for {EL_LOCALE_STRING_ITEM_RADIO_BUTTON_GROUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
