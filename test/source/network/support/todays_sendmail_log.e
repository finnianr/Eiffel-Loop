note
	description: "[$source SENDMAIL_TODAYS_LOG] with today fixed to Oct 8th for test purposes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-27 11:32:57 GMT (Friday 27th October 2023)"
	revision: "1"

class
	TODAYS_SENDMAIL_LOG

inherit
	EL_TODAYS_SENDMAIL_LOG
		redefine
			is_new_day
		end

create
	make

feature {NONE} -- Implementation

	is_new_day: BOOLEAN
		-- fixed to Oct 8th for test purposes
		do
			Result := Precursor
			today.set_day (8)
			today.set_month (10)
		end

end