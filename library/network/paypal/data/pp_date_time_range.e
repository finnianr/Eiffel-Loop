note
	description: "Paypal date-time range"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-14 6:39:18 GMT (Friday 14th May 2021)"
	revision: "2"

class
	PP_DATE_TIME_RANGE

inherit
	PP_CONVERTABLE_TO_PARAMETER_LIST

create
	make, make_to_now

feature {NONE} -- Initialization

	make (a_start_date, a_end_date: DATE_TIME)
			-- examples: en_US, de_DE
		do
			make_default
			start_date := a_start_date; end_date := a_end_date
		end

	make_to_now (a_start_date: DATE_TIME)
		do
			make_default
			start_date := a_start_date
			create end_date.make_now
		end

feature -- Paypal parameters

	end_date: EL_ISO_8601_DATE_TIME

	start_date: EL_ISO_8601_DATE_TIME

end