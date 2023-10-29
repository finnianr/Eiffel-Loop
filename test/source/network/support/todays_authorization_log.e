note
	description: "[$source EL_TODAYS_AUTHORIZATION_LOG] with today fixed to Oct 22th for test purposes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-29 12:40:02 GMT (Sunday 29th October 2023)"
	revision: "1"

class
	TODAYS_AUTHORIZATION_LOG

inherit
	EL_TODAYS_AUTHORIZATION_LOG
		redefine
			is_new_day
		end

create
	make

feature {NONE} -- Implementation

	is_new_day: BOOLEAN
		-- fixed to Oct 22th for test purposes
		do
			Result := Precursor
			today.set_day (22)
			today.set_month (10)
		end

end