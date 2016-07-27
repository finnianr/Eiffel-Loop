note
	description: "Summary description for {MODULE_HEXAGRAM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-03-17 10:20:32 GMT (Thursday 17th March 2016)"
	revision: "7"

class
	MODULE_HEXAGRAM

feature {NONE} -- Constants

	Hexagram: I_CHING_HEXAGRAM_CONSTANTS
		once
			create Result.make
		end
end