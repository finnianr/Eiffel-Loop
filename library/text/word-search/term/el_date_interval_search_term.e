note
	description: "Summary description for {DATE_INTERVAL_SEARCH_TERM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-13 10:16:43 GMT (Wednesday 13th January 2016)"
	revision: "4"

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

	positive_match (target: like Type_target): BOOLEAN
			--
		do
			Result := target.between (from_date, to_date)
		end
end
