note
	description: "Module hexagram"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-13 13:29:28 GMT (Wednesday 13th February 2019)"
	revision: "5"

class
	EL_MODULE_HEXAGRAM

feature {NONE} -- Constants

	Hexagram: EL_HEXAGRAM_STRINGS
		once
			create Result.make
		end
end
