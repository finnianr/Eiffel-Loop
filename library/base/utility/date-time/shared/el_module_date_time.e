note
	description: "Shared access to instance of [$source EL_DATE_TIME_TOOLS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-13 9:10:40 GMT (Friday 13th August 2021)"
	revision: "3"

deferred class
	EL_MODULE_DATE_TIME

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Date_time: EL_DATE_TIME_TOOLS
		once
			create Result
		end
end