note
	description: "C externals for ${C_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2026 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"

	date: "2026-06-29 6:31:14 GMT (Monday 29th June 2026)"
	revision: "1"

class
	C_STRING_8_API

feature {NONE} -- C Externals

	frozen c_strcmp_n (p1: POINTER; n1: INTEGER; p2: POINTER; n2: INTEGER): INTEGER
			-- Lexicographic comparison of `n1' bytes at `p1' with `n2' bytes at `p2'.
			-- Returns negative if p1 < p2, zero if equal, positive if p1 > p2.
		external
			"C inline use <string.h>"
		alias
			"[
				int n = ($n1 < $n2) ? $n1 : $n2;
				int cmp = memcmp($p1, $p2, n);
				if (cmp != 0) return cmp;
				return ($n1 < $n2) ? -1 : ($n1 > $n2) ? 1 : 0;
			]"
		end

	frozen c_string_8_length (a_area: POINTER): INTEGER
			-- length of null terminated string at `a_area'.
		external
			"C inline"
		alias
			"return ((EIF_INTEGER_32 *)strlen ($a_area));"
		end

	frozen c_memory_compare (p1, p2: POINTER; n: INTEGER): BOOLEAN
		-- True if first `n' bytes at `p1' and `p2' are identical.
		external
			"C inline use <string.h>"
		alias
			"return (memcmp ($p1, $p2, $n) == 0);"
		end

	frozen c_read_character_8 (a_area: POINTER; i: INTEGER): CHARACTER_8
			-- Character at offset `i' in buffer `a_area'.
		external
			"C inline"
		alias
			"return ((EIF_CHARACTER_8 *)$a_area)[$i];"
		end

end
