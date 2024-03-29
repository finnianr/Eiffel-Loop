note
	description: "Shared instance of ${HEXAGRAM_STRINGS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "11"

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