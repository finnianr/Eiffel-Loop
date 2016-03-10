note
	description: "Summary description for {EL_LOCALE_SCROLLABLE_SEARCH_RESULTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

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

	Link_text_previous: EL_ASTRING
		once
			Result := Locale * "Previous"
		end

	Link_text_next: EL_ASTRING
		once
			Result := Locale * "Next"
		end

end
