note
	description: "Summary description for {PP_DATE_TIME_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 5:44:24 GMT (Monday 18th December 2017)"
	revision: "5"

class
	PP_DATE_TIME_PARAMETER

inherit
	PP_NAME_VALUE_PARAMETER
		rename
			value as date_value
		end

	EL_MODULE_DATE

	PP_SHARED_PARAMETER_ENUM

create
	make_start, make_end

feature {NONE} -- Initialization

	make_start (date_time: DATE_TIME)
		do
			make_with_code (Parameter.start_date, date_time)
		end

	make_end (date_time: DATE_TIME)
		do
			make_with_code (Parameter.end_date, date_time)
		end

	make_with_code (a_code: NATURAL_8; date_time: DATE_TIME)
		do
			make (a_code, Date.iso_8601_formatted (date_time, True))
		end

end
