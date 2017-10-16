note
	description: "Summary description for {EL_DATE_STAMPED}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

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