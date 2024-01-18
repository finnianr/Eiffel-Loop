note
	description: "Shared instance of ${HEXAGRAM_STRINGS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 7:43:08 GMT (Monday 12th December 2022)"
	revision: "10"

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