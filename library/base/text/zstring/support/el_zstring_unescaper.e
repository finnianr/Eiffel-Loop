note
	description: "Unescape strings conforming to ${EL_READABLE_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-04 10:17:34 GMT (Monday 4th December 2023)"
	revision: "20"

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
			l_count, i, seq_count, block_index: INTEGER; z_code_i, esc_code: NATURAL
			l_area: SPECIAL [CHARACTER_8]; area_32: SPECIAL [CHARACTER_32]
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION

		do
			l_count := str.count; l_area := str.area
			esc_code := escape_code

			create Result.make_empty (l_count)
			area_32 := str.unencoded_area
			from i := 0 until i = l_count loop
				z_code_i := iter.i_th_z_code ($block_index, l_area, area_32, i)
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