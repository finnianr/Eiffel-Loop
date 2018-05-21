note
	description: "Module hexagram"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	MODULE_HEXAGRAM

feature {NONE} -- Constants

	Hexagram: I_CHING_HEXAGRAM_CONSTANTS
		once
			create Result.make
		end
end