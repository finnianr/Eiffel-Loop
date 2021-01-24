note
	description: "Light-weight version of [$source EL_ZSTRING] for testing class [$source EL_SUBSTRING_32_ARRAY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-24 16:47:01 GMT (Sunday 24th January 2021)"
	revision: "2"

class
	L1_ZSTRING

inherit
	STRING
		redefine
			to_string_32
		end

	EL_SUBSTRING_32_ARRAY
		rename
			append as array_append,
			area as array_area,
			count as array_count,
			code as array_code,
			Empty_area as Empty_array_area,
			has as array_has,
			hash_code as array_hash_code,
			last_index_of as array_last_index_of,
			index_of as array_index_of,
			insert as array_insert,
			item as array_item,
			not_empty as array_not_empty,
			make_empty as array_make_empty,
			occurrences as array_occurrences,
			prepend as array_prepend,
			remove_substring as array_remove_substring,
			same_string as array_same_string,
			valid_index as array_valid_index
		undefine
			copy, is_equal, out
		end

	EL_ZCODE_CONVERSION undefine copy, is_equal, out end

create
	make_from_general

convert
	make_from_general ({STRING_32})

feature {NONE} -- Initialization

	make_from_general (s: READABLE_STRING_GENERAL)
		do
			make_empty
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
				Result := array_code (i)
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
					buffer.put_character (uc, i)
					l_area.put (Unencoded_character, i - 1)
				else
					l_area.put (uc.to_character_8, i - 1)
				end
				i := i + 1
			end
			make_from_area (buffer.to_substring_area)
		end

feature {NONE} -- Constants

	Once_substrings_buffer: EL_SUBSTRING_32_LIST
		once
			create Result.make (10)
		end

end