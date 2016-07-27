note
	description: "Summary description for {EL_LOCALE_DROP_DOWN_LIST_BOX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-26 11:23:27 GMT (Saturday 26th December 2015)"
	revision: "8"

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