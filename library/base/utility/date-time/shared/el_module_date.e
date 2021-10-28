note
	description: "Shared access to routines of class [$source EL_DATE_TEXT]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-28 13:12:23 GMT (Thursday 28th October 2021)"
	revision: "10"

deferred class
	EL_MODULE_DATE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Date: EL_DATE_TEXT
			--
		once
			create Result.make_default
		end

end