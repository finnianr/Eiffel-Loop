note
	description: "Paypal date-time range"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-06 11:04:41 GMT (Wednesday 6th December 2023)"
	revision: "4"

class
	PP_DATE_TIME_RANGE

inherit
	PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER

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