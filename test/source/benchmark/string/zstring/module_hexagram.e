note
	description: "Summary description for {MODULE_HEXAGRAM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-11-04 14:21:13 GMT (Wednesday 4th November 2015)"
	revision: "5"

class
	MODULE_HEXAGRAM

feature {NONE} -- Constants

	Hexagram: I_CHING_HEXAGRAM_CONSTANTS
		once
			create Result.make
		end
end
