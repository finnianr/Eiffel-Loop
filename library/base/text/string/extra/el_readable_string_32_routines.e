note
	description: "Routines with ${READABLE_STRING_32} arguments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-13 9:53:29 GMT (Saturday 13th July 2024)"
	revision: "1"

deferred class
	EL_READABLE_STRING_32_ROUTINES [S -> READABLE_STRING_32]

inherit
	EL_STRING_32_BIT_COUNTABLE [S]

feature -- Character query

	ends_with_character (s: S; c: CHARACTER_32): BOOLEAN
		local
			i: INTEGER
		do
			i := s.count
			Result := i > 0 and then s [i] = c
		end

	starts_with_character (s: S; c: CHARACTER_32): BOOLEAN
		do
			Result := s.count > 0 and then s [1] = c
		end

feature -- Comparison

	ends_with (s, trailing: S): BOOLEAN
		do
			Result := s.ends_with (trailing)
		end

	occurs_at (big, small: S; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		do
			Result := big.same_characters (small, 1, small.count, index)
		end

	occurs_caseless_at (big, small: S; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		do
			Result := big.same_caseless_characters (small, 1, small.count, index)
		end

	starts_with (s, leading: S): BOOLEAN
		do
			Result := s.starts_with (leading)
		end

end