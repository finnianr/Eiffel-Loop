note
	description: "String for testing class [$source EL_SUBSTRING_32_ARRAY] and  [$source EL_SUBSTRING_32_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-05 12:38:19 GMT (Saturday 5th December 2020)"
	revision: "2"

class
	L1_UC_STRING

inherit
	STRING
		redefine
			to_string_32
		end

	EL_SUBSTRING_32_ARRAY
		rename
			make as make_substrings,
			substring_index as substrings_index,
			count as substrings_count,
			has as substrings_has
		undefine
			copy, is_equal, out
		end

	EL_ZCODE_CONVERSION undefine copy, is_equal, out end

create
	make_from_general

feature {NONE} -- Initialization

	make_from_general (s: READABLE_STRING_GENERAL)
		do
			make_substrings
			make_filled ('%U', s.count)
			encode (s, 0)
		end

feature -- Access

	unicode (i: INTEGER): NATURAL_32
			-- Numeric code of character at position `i'.
		local
			c_i: CHARACTER
		do
			c_i := area.item (i - 1)
			if c_i = Unencoded_character then
				Result := code_item (i)
			else
				Result := c_i.code.to_natural_32
			end
		end

feature -- Conversion

	to_string_32: STRING_32
		local
			l_area: like area; i, l_count: INTEGER
			c_i: CHARACTER
		do
			create Result.make_filled (' ', count)
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				Result.area [i] := l_area [i]
				i := i + 1
			end
			write (Result.area, 0)
		end

feature {NONE} -- Implementation

	encode (a_unicode: READABLE_STRING_GENERAL; area_offset: INTEGER)
		local
			buffer: like Once_substrings_buffer; l_area: like area
			i, uc_count: INTEGER; uc: CHARACTER_32
		do
			buffer := Once_substrings_buffer; buffer.wipe_out
			l_area := area
			uc_count := a_unicode.count
			from i := 1 until i > uc_count loop
				uc := a_unicode [i]
				if uc.natural_32_code > 0xFF then
					buffer.append_character (uc, i)
					l_area.put (Unencoded_character, i - 1)
				else
					l_area.put (uc.to_character_8, i - 1)
				end
				i := i + 1
			end
			buffer.finalize
			substring_area := buffer.area_copy
		end

feature {NONE} -- Constants

	Once_substrings_buffer: EL_SUBSTRING_32_LIST
		once
			create Result.make
		end
end