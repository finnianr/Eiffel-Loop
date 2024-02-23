note
	description: "Paypal date-time range"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-23 10:23:44 GMT (Friday 23rd February 2024)"
	revision: "5"

class
	PP_DATE_TIME_RANGE

inherit
	PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER

create
	make, make_to_now, make_millenium

feature {NONE} -- Initialization

	make (a_start_date, a_end_date: DATE_TIME)
			-- examples: en_US, de_DE
		do
			make_default
			start_date := a_start_date; end_date := a_end_date
		end

	make_millenium
		-- make from the start of the millenium to now
		do
			make_to_now (create {DATE_TIME}.make (2000, 1, 1, 0, 0, 0))
		end

	make_to_now (a_start_date: DATE_TIME)
		do
			make (a_start_date, create {DATE_TIME}.make_now_utc)
		end

feature -- Paypal parameters

	end_date: EL_ISO_8601_DATE_TIME

	start_date: EL_ISO_8601_DATE_TIME

end