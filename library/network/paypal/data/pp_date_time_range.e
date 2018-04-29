note
	description: "Paypal date-time range"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 15:08:55 GMT (Saturday 28th April 2018)"
	revision: "1"

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
			create start_date.make_from_other (a_start_date)
			create end_date.make_from_other (a_end_date)
		end

	make_to_now (a_start_date: DATE_TIME)
		do
			make_default
			create start_date.make_from_other (a_start_date)
			create end_date.make_now
		end

feature -- Paypal parameters

	end_date: EL_ISO_8601_DATE_TIME

	start_date: EL_ISO_8601_DATE_TIME

end
