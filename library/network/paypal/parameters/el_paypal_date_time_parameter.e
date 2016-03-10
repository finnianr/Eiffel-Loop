note
	description: "Summary description for {EL_PAYPAL_DATE_TIME_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-31 17:48:01 GMT (Tuesday 31st March 2015)"
	revision: "5"

class
	EL_PAYPAL_DATE_TIME_PARAMETER

inherit
	EL_HTTP_NAME_VALUE_PARAMETER
		rename
			make as make_parameter,
			value as date_value
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: like name; date_time: DATE_TIME)
		do
			make_parameter (a_name, date_time.formatted_out (Date_format))
			date_value [11] := 'T'
			date_value.append_character ('Z')
		end

feature {NONE} -- Constants

	Date_format: STRING = "yyyy-[0]mm-[0]dd [0]hh:[0]mi:[0]ss";
end
