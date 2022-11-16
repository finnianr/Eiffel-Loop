note
	description: "Date interval search term"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_DATE_INTERVAL_CONDITION [G -> {EL_WORD_SEARCHABLE, EL_DATEABLE}]

inherit
	EL_QUERY_CONDITION [G]

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

	met (item: G): BOOLEAN
			--
		do
			Result := item.between (from_date, to_date)
		end
end