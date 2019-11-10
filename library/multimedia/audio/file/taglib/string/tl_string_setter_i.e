note
	description: "Translate string to `wchar_t *' C array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 19:05:55 GMT (Sunday 10th November 2019)"
	revision: "1"

deferred class
	TL_STRING_SETTER_I

inherit
	ANY EL_SHARED_ONCE_STRING_32

feature -- Basic operations

	set_string (target: TL_STRING; a_source: ZSTRING)
		local
			source: STRING_32
		do
			source := empty_once_string_32
			a_source.append_to_string_32 (source)
			set_string_32 (target, source)
		end

	set_string_32 (target: TL_STRING; source: STRING_32)
		local
			area: like utf_16_area
			i, n, m, p: INTEGER; c: NATURAL_32
		do
			area := utf_16_area; area.wipe_out
			from
				m := 0
				n := source.count
				p := n
				area := area.aliased_resized_area (p + 1)
			until
				i >= n
			loop
				i := i + 1
					-- Make sure there is sufficient room for at least 2 code units.
				if p < m + 2 then
					p := m + (n - i) + 2
					area := area.aliased_resized_area (p + 1)
				end
				c := source.code (i)
				if c <= 0xFFFF then
						-- Codepoint from Basic Multilingual Plane: one 16-bit code unit.
					extend (area, c)
					m := m + 1
				else
						-- Supplementary Planes: surrogate pair with lead and trail surrogates.
					extend (area, 0xD7C0 + (c |>> 10))
					extend (area, 0xDC00 + (c & 0x3FF))
					m := m + 2
				end
			end
			extend (area, 0)
			target.set_from_utf_16 (area.base_address)
			utf_16_area := area
		end

	set_string_8 (target: TL_STRING; a_source: STRING)
		local
			source: STRING_32
		do
			source := empty_once_string_32
			source.append_string_general (a_source)
			set_string_32 (target, source)
		end

feature {NONE} -- Implementation

	extend (area: like utf_16_area; code: NATURAL)
		deferred
		end

feature {NONE} -- Internal attributes

	utf_16_area: SPECIAL [NUMERIC]
end
