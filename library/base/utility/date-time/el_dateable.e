note
	description: "An object that as field `date' conforming to [$source DATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-02 12:56:31 GMT (Tuesday 2nd March 2021)"
	revision: "7"

deferred class
	EL_DATEABLE

feature -- Access

	date: DATE
		deferred
		end

feature -- Status query

	between (from_date, to_date: DATE): BOOLEAN
		local
			l_date: like date
		do
			l_date := date
			Result := from_date <= l_date and then l_date <= to_date
		end

end