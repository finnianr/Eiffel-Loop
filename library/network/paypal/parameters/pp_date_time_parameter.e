note
	description: "Summary description for {PP_DATE_TIME_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	PP_DATE_TIME_PARAMETER

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
