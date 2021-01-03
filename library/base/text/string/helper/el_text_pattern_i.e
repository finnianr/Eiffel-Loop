note
	description: "Abstract text pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-17 13:48:57 GMT (Monday 17th December 2018)"
	revision: "6"

deferred class
	EL_TEXT_PATTERN_I

feature -- Status query

	matches_string_general (s: READABLE_STRING_GENERAL): BOOLEAN
		deferred
		end

end
