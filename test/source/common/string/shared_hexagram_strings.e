note
	description: "Module hexagram"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-26 14:59:08 GMT (Sunday 26th December 2021)"
	revision: "7"

deferred class
	SHARED_HEXAGRAM_STRINGS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Hexagram: HEXAGRAM_STRINGS
		once
			create Result.make
		end
end