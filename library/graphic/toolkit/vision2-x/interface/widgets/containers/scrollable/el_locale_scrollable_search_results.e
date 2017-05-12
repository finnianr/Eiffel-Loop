note
	description: "Summary description for {EL_LOCALE_SCROLLABLE_SEARCH_RESULTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-27 12:08:55 GMT (Thursday 27th April 2017)"
	revision: "2"

class
	EL_LOCALE_SCROLLABLE_SEARCH_RESULTS [G -> {EL_HYPERLINKABLE, EL_WORD_SEARCHABLE}]

inherit
	EL_SCROLLABLE_SEARCH_RESULTS [G]
		redefine
			Link_text_previous, Link_text_next, new_formatted_date
		end

	EL_MODULE_LOCALE
		undefine
			is_equal, copy, default_create
		end

create
	make, default_create

feature {NONE} -- Factory

	new_formatted_date (date: DATE): EL_STYLED_ZSTRING
		do
			Result := Locale.date_text.formatted (date, date_format)
		end

feature {NONE} -- Constants

	Link_text_next: ZSTRING
		once
			Result := Locale * "Next"
		end

	Link_text_previous: ZSTRING
		once
			Result := Locale * "Previous"
		end

end
