note
	description: "Module hexagram"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 13:54:29 GMT (Thursday 6th February 2020)"
	revision: "6"

class
	SHARED_HEXAGRAM_STRINGS

feature {NONE} -- Constants

	Hexagram: HEXAGRAM_STRINGS
		once
			create Result.make
		end
end
