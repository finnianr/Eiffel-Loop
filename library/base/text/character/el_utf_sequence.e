note
	description: "[
		UTF sequence for single unicode character. See descendants: [$source EL_UTF_8_SEQUENCE] and
		[$source EL_UTF_16_SEQUENCE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-09 12:28:39 GMT (Monday 9th April 2018)"
	revision: "1"

class
	EL_UTF_SEQUENCE

inherit
	TO_SPECIAL [NATURAL]

feature -- Access

	count: INTEGER

feature -- Element change

	wipe_out
		do
			count := 0
		end

	extend (n: NATURAL)
		require
			valid_n: count + 1 <= area.count
		do
			area [count] := n
			count := count + 1
		end
end
