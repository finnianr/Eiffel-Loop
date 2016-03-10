note
	description: "Summary description for {EL_MODULE_TEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-14 22:59:21 GMT (Friday 14th June 2013)"
	revision: "2"

class
	EL_MODULE_TEST

inherit
	EL_MODULE

feature -- Access

	Test: EL_TEST_ROUTINES
			--
		once
			create Result.make
		end

end
