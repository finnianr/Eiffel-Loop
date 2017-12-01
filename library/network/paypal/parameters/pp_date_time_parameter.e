note
	description: "Summary description for {PP_DATE_TIME_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-23 16:12:07 GMT (Thursday 23rd November 2017)"
	revision: "3"

class
	PP_DATE_TIME_PARAMETER

inherit
	EL_HTTP_NAME_VALUE_PARAMETER
		rename
			make as make_parameter,
			value as date_value
		end

	EL_MODULE_DATE

create
	make

feature {NONE} -- Initialization

	make (a_name: like name; date_time: DATE_TIME)
		do
			make_parameter (a_name, Date.canonical_iso8601_formatted (date_time))
		end

end
