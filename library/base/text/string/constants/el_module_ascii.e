note
	description: "Shared access to base class `ASCII'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-10 12:19:11 GMT (Sunday 10th January 2021)"
	revision: "6"

class
	EL_MODULE_ASCII

feature {NONE} -- Constants

	Ascii: ASCII
		once
			create Result
		end
end