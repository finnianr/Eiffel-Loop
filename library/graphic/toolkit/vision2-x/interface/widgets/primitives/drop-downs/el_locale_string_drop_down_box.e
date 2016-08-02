note
	description: "Drop down box with localized display strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-29 12:30:07 GMT (Friday 29th July 2016)"
	revision: "1"

class
	EL_LOCALE_STRING_DROP_DOWN_BOX

inherit
	EL_ZSTRING_DROP_DOWN_BOX
		rename
			displayed_text as translation
		redefine
			translation
		end

	EL_MODULE_LOCALE
		undefine
			default_create, copy, is_equal
		end

create
	make, make_unadjusted, make_alphabetical, make_alphabetical_unadjusted

feature {NONE} -- Implementation

	translation (string: ZSTRING): ZSTRING
		do
			Result := Locale * string
		end

end
