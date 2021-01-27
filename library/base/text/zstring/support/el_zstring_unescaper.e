note
	description: "[
		Z-code escape table for use with class [$source EL_ZSTRING]. See routine `escape'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-27 17:05:04 GMT (Wednesday 27th January 2021)"
	revision: "12"

class
	EL_ZSTRING_UNESCAPER

inherit
	EL_STRING_GENERAL_UNESCAPER [EL_READABLE_ZSTRING, ZSTRING]
		redefine
			character_to_code, i_th_code
		end

	EL_SHARED_ZSTRING_CODEC

	EL_ZCODE_CONVERSION undefine copy, is_equal end

create
	make

feature -- Access

	unescaped (str: EL_READABLE_ZSTRING): EL_ZSTRING
		do
			create Result.make_from_zcode_area (unescaped_array (str))
		end

	unescaped_array (str: EL_READABLE_ZSTRING): SPECIAL [NATURAL]
		local
			l_count, i, seq_count: INTEGER; z_code_i, esc_code: NATURAL; c_i: CHARACTER
			l_area: SPECIAL [CHARACTER_8]; iterator: EL_INDEXABLE_SUBSTRING_32_ARRAY_ITERATOR
		do
			l_count := str.count; l_area := str.area
			esc_code := escape_code

			create Result.make_empty (l_count)
			iterator := str.indexable_iterator
			from i := 0 until i = l_count loop
				c_i := l_area [i]
				if c_i = Unencoded_character then
					z_code_i := iterator.z_code (i + 1)
				else
					z_code_i := c_i.natural_32_code
				end
				if z_code_i = esc_code then
					seq_count := sequence_count (str, i + 2)
					if seq_count.to_boolean then
						z_code_i := unescaped_code (i + 2, seq_count)
					end
				else
					seq_count := 0
				end
				Result.extend (z_code_i)
				i := i + seq_count + 1
			end
		end

feature -- Basic operations

	unescape (str: ZSTRING)
		do
			if str.has_unicode (escape_code) then
				str.share (unescaped (str))
			end
		end

	unescape_into (str: EL_READABLE_ZSTRING; output: ZSTRING)
		do
			output.append (create {ZSTRING}.make_from_zcode_area (unescaped_array (str)))
		end

feature {NONE} -- Implementation

	character_to_code (character: CHARACTER_32): NATURAL
		do
			Result := Codec.as_z_code (character)
		end

	i_th_code (str: EL_READABLE_ZSTRING; index: INTEGER): NATURAL
		do
			Result := str.z_code (index)
		end

end