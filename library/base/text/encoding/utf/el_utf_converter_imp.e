note
	description: "UTF string converter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-03 16:56:19 GMT (Sunday 3rd September 2023)"
	revision: "16"

class
	EL_UTF_CONVERTER_IMP

inherit
	UTF_CONVERTER
		export
			{NONE} utf_8_string_8_into_string_32
		redefine
			is_valid_utf_16
		end

	STRING_HANDLER

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_IMMUTABLE_8_MANAGER

feature -- Status report

	is_utf_16_le_file (text: READABLE_STRING_8): BOOLEAN
		-- `True' if file `text' is encoded as little-endian UTF-16
		do
			Result := text.starts_with (Utf_16le_bom_to_string_8)
		end

	is_utf_8_file (text: READABLE_STRING_8): BOOLEAN
		-- `True' if file `text' is encoded as UTF-8
		do
			Result := text.starts_with (Utf_8_bom_to_string_8)
		end

	is_valid_utf_16 (s: SPECIAL [NATURAL_16]): BOOLEAN
			-- Is `s' a valid UTF-16 Unicode sequence?
		local
			i, n: INTEGER; c1, c2: NATURAL_32
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

feature -- Conversion

	bomless_utf_16_le (text: STRING_8): READABLE_STRING_8
		-- file `text' without the little-endian UTF-16 byte-order-mark
		require
			has_16le_bom: is_utf_16_le_file (text)
		do
			Result := bomless_text (Utf_16le_bom_to_string_8, text)
		end

	bomless_utf_8 (text: STRING_8): READABLE_STRING_8
		-- file `text' without the UTF-8 byte-order-mark
		require
			has_utf_8_bom: is_utf_8_file (text)
		do
			Result := bomless_text (Utf_8_bom_to_string_8, text)
		end

feature -- UTF-16 operations

	utf_16_be_0_pointer_into_string_32 (p: MANAGED_POINTER; a_result: STRING_32)
			-- Copy {STRING_32} object corresponding to UTF-16BE sequence `p' which is zero-terminated
			-- appended into `a_result'.
		require
			minimum_size: p.count >= 2
			valid_count: p.count \\ 2 = 0
		do
			utf_16_be_0_subpointer_into_string_32 (p, 0, p.count // 2 - 1, True, a_result)
		end

	utf_16_be_0_subpointer_into_string_32 (p: MANAGED_POINTER; start_pos, end_pos: INTEGER; a_stop_at_null: BOOLEAN; a_result: STRING_32)
			-- Copy {STRING_32} object corresponding to UTF-16BE sequence `p' between code units `start_pos' and
			-- `end_pos' or the first null character encountered if `a_stop_at_null' appended into `a_result'.
		require
			minimum_size: p.count >= 2
			start_position_big_enough: start_pos >= 0
			end_position_big_enough: start_pos <= end_pos + 1
			end_pos_small_enough: end_pos < p.count // 2
		local
			i, n: INTEGER
			c: NATURAL_32
		do
			from
					-- Allocate Result with the same number of bytes as copied from `p'.
				a_result.grow (a_result.count + end_pos - start_pos + 1)
				i := start_pos * 2
				n := end_pos * 2
			until
				i > n
			loop
				c := p.read_natural_16_be (i)
				if c = 0 and a_stop_at_null then
						-- We hit our null terminating character, we can stop
					i := n + 1
				else
					i := i + 2
					if c < 0xD800 or c >= 0xE000 then
							-- Codepoint from Basic Multilingual Plane: one 16-bit code unit.
						a_result.extend (c.to_character_32)
					else
							-- Supplementary Planes: surrogate pair with lead and trail surrogates.
						if i <= n then
							a_result.extend (((c.as_natural_32 |<< 10) + p.read_natural_16_be (i) - 0x35FDC00).to_character_32)
							i := i + 2
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	bomless_text (bom, text: STRING_8): READABLE_STRING_8
		-- file `text' without the UTF-8 byte-order-mark
		do
			if bom.count > 0 then
				Result := Immutable_8.shared_substring (text, bom.count + 1, text.count)
			else
				Result := text
			end
		end
end
