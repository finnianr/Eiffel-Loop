note
	description: "Summary description for {EL_MODULE_ASCII}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-13 8:21:28 GMT (Sunday 13th August 2017)"
	revision: "2"

class
	EL_MODULE_ASCII

feature -- Access

	Ascii: ASCII
		once
			create Result
		end
end
