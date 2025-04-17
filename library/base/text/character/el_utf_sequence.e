note
	description: "UTF sequence for single unicode character."
	descendants: "[
			EL_UTF_SEQUENCE
				${EL_UTF_8_SEQUENCE}
				${EL_UTF_16_SEQUENCE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 17:36:23 GMT (Tuesday 15th April 2025)"
	revision: "8"

class
	EL_UTF_SEQUENCE

inherit
	TO_SPECIAL [NATURAL]

	EL_UC_ROUTINES_I
		rename
			utf_8_byte_count as byte_count
		end

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