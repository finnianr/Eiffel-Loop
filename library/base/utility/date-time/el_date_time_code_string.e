note
	description: "Factory for date-time string parsing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-14 10:36:40 GMT (Friday 14th May 2021)"
	revision: "1"

class
	EL_DATE_TIME_CODE_STRING

inherit
	DATE_TIME_CODE_STRING
		rename
			create_string as new_string,
			create_date as new_date,
			create_date_time as new_date_time,
			create_time_string as new_time_string
		end

create
	make

feature -- Access

	new_parser: DATE_TIME_PARSER
			-- Parser from `s'.
			-- Build a new one if necessary.
		do
			create Result.make (value)
			Result.set_day_array (days)
			Result.set_month_array (months)
			Result.set_base_century (base_century)
		end

end