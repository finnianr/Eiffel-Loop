note
	description: "Summary description for {EL_UTF_CONVERTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-11 14:37:23 GMT (Wednesday 11th April 2018)"
	revision: "2"

expanded class
	EL_UTF_CONVERTER

inherit
	UTF_CONVERTER
		redefine
			is_valid_utf_16
		end

feature -- Status query

	is_valid_utf_16 (s: SPECIAL [NATURAL_16]): BOOLEAN
			-- Is `s' a valid UTF-16 Unicode sequence?
		local
			i, n: INTEGER
			c1, c2: NATURAL_32
		do
			from
				i := 0
				n := s.count
				Result := True
			until
				i >= n or not Result
			loop
				c1 := s.item (i)
				if c1 = 0 then
						-- We hit our null terminating character, we can stop
					i := n + 1
				else
					if c1 < 0xD800 or c1 >= 0xE000 then
						-- Codepoint from Basic Multilingual Plane: one 16-bit code unit, this is valid Unicode.
						i := i + 1
					elseif c1 <= 0xDBFF then
						i := i + 1
						if i <= n then
							c2 := s.item (i)
							Result := 0xDC00 <= c2 and c2 <= 0xDFF
						else
								-- Surrogate pair is incomplete, clearly not a valid UTF-16 sequence.
							Result := False
						end
					else
							-- Invalid starting surrogate pair which should be between 0xD800 and 0xDBFF.
						Result := False
					end
				end
			end
		end

end
