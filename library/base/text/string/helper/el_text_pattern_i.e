note
	description: "Abstract text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_TEXT_PATTERN_I

feature -- Status query

	matches_string_general (s: READABLE_STRING_GENERAL): BOOLEAN
		deferred
		end

end