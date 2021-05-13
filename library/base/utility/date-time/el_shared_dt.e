note
	description: "Shared access to instance of [$source EL_DATE_TIME_TOOLS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-13 13:11:22 GMT (Thursday 13th May 2021)"
	revision: "1"

deferred class
	EL_SHARED_DT

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	DT: EL_DATE_TIME_TOOLS
		once
			create Result
		end
end