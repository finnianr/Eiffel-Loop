note
	description: "Summary description for {EL_MODULE_DATE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-07 10:07:39 GMT (Sunday 7th August 2016)"
	revision: "2"

class
	EL_MODULE_DATE

inherit
	EL_MODULE

feature -- Access

	Date: EL_ENGLISH_DATE_TEXT
			--
		once
			create Result.make
		end

end
