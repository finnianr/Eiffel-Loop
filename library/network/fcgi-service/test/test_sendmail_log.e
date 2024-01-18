note
	description: "[
		Test ${EL_TODAYS_SENDMAIL_LOG} using data from: `test/data/network/mail.log'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-30 11:35:58 GMT (Monday 30th October 2023)"
	revision: "2"

class
	TEST_SENDMAIL_LOG

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