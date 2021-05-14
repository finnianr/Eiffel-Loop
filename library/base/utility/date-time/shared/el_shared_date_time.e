note
	description: "Shared access to instance of [$source EL_DATE_TIME_TOOLS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-14 8:58:59 GMT (Friday 14th May 2021)"
	revision: "2"

deferred class
	EL_SHARED_DATE_TIME

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Date_time: EL_DATE_TIME_TOOLS
		once
			create Result
		end
end