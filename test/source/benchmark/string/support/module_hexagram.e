note
	description: "Module hexagram"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	MODULE_HEXAGRAM

feature {NONE} -- Constants

	Hexagram: I_CHING_HEXAGRAM_CONSTANTS
		once
			create Result.make
		end
end