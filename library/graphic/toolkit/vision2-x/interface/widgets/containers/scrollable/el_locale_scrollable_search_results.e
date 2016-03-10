note
	description: "Summary description for {EL_LOCALE_SCROLLABLE_SEARCH_RESULTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_LOCALE_SCROLLABLE_SEARCH_RESULTS [G -> {EL_HYPERLINKABLE, EL_WORD_SEARCHABLE}]

inherit
	EL_SCROLLABLE_SEARCH_RESULTS [G]
		redefine
			Link_text_previous, Link_text_next
		end

	EL_MODULE_LOCALE
		undefine
			is_equal, copy, default_create
		end

create
	make, default_create

feature {NONE} -- Constants

	Link_text_previous: ASTRING
		once
			Result := Locale * "Previous"
		end

	Link_text_next: ASTRING
		once
			Result := Locale * "Next"
		end

end
