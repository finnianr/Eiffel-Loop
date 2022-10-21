note
	description: "Module hexagram"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-19 11:33:35 GMT (Wednesday 19th October 2022)"
	revision: "8"

deferred class
	SHARED_HEXAGRAM_STRINGS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Hexagram: HEXAGRAM_STRINGS
		once
			create Result
		end
end