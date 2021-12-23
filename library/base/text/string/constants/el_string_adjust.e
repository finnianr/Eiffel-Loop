note
	description: "String adjustment status that can be combined with ''bit_or'' operator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-23 11:17:36 GMT (Thursday 23rd December 2021)"
	revision: "2"

class
	EL_STRING_ADJUST

feature -- Constants

	Both: INTEGER = 3

	Left: INTEGER = 1

	None: INTEGER = 0

	Right: INTEGER = 2

invariant
	left_is_one: Left = 1 -- Allows `left_adjusted.to_integer'
end