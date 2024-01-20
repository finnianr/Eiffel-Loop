note
	description: "Shared access to instance of ${EL_DATE_TIME_TOOLS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "5"

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