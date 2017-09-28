note
	description: "Summary description for {DATE_INTERVAL_SEARCH_TERM}."

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-24 13:16:38 GMT (Sunday 24th September 2017)"
	revision: "2"

class
	EL_DATE_INTERVAL_SEARCH_TERM [G -> {EL_WORD_SEARCHABLE, EL_DATEABLE}]

inherit
	EL_CUSTOM_SEARCH_TERM [G]

create
	make

feature {NONE} -- Initialization

	make (a_from_date, a_to_date: DATE)
			--
		do
			from_date := a_from_date; to_date := a_to_date
		end

feature -- Access

	from_date: DATE

	to_date: DATE

feature {NONE} -- Implementation

	positive_match (target: like WORD_SEARCHABLE): BOOLEAN
			--
		do
			Result := target.between (from_date, to_date)
		end
end
