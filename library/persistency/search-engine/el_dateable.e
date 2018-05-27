note
	description: "Dateable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

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