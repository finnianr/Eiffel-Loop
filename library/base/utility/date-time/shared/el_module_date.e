note
	description: "Shared access to routines of class [$source EL_ENGLISH_DATE_TEXT]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-14 8:18:19 GMT (Friday 14th May 2021)"
	revision: "9"

deferred class
	EL_MODULE_DATE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Date: EL_ENGLISH_DATE_TEXT
			--
		once
			create Result.make
		end

end