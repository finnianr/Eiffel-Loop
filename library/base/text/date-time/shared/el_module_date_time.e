note
	description: "Shared access to instance of ${EL_DATE_TIME_TOOLS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

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