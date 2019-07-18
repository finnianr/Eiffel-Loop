note
	description: "Drop down box with localized display strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 11:43:08 GMT (Monday 1st July 2019)"
	revision: "5"

class
	EL_LOCALE_ZSTRING_DROP_DOWN_BOX

inherit
	EL_ZSTRING_DROP_DOWN_BOX
		rename
			displayed_text as translation
		redefine
			translation
		end

	EL_MODULE_DEFERRED_LOCALE

create
	default_create, make, make_unadjusted, make_sorted, make_unadjusted_sorted

feature {NONE} -- Implementation

	translation (string: ZSTRING): ZSTRING
		do
			Result := Locale * string
		end

end
