note
	description: "UTF sequence for single unicode character."
	descendants: "[
			EL_UTF_SEQUENCE
				[$source EL_UTF_8_SEQUENCE]
				[$source EL_UTF_16_SEQUENCE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-22 12:58:06 GMT (Sunday 22nd April 2018)"
	revision: "2"

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
