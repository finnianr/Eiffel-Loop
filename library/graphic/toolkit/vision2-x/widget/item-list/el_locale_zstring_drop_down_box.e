note
	description: "Drop down box with localized display strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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