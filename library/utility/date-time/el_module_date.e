note
	description: "Summary description for {EL_MODULE_DATE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MODULE_DATE

inherit
	EL_MODULE

feature -- Access

	Date: EL_ENGLISH_DATE_ROUTINES
			--
		once
			create Result
		end

end
