note
	description: "Writing contents of [$source ZSTRING] to external strings/objects"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-20 10:16:52 GMT (Friday 20th October 2023)"
	revision: "8"

deferred class
	EL_WRITEABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_READABLE_ZSTRING_I

feature -- Write to other

	write_latin (writeable: EL_WRITABLE)
		-- write `area' sequence as raw characters to `writeable'
		local
			i, l_count: INTEGER; l_area: like area
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				writeable.write_raw_character_8 (l_area [i])
				i := i + 1
			end
		end

feature -- Append to other

	append_to (other: EL_ZSTRING)
		do
			other.append (current_readable)
		end

	append_to_general (other: STRING_GENERAL)
		do
			if other.is_string_8 and then attached {STRING_8} other as str_8 then
				append_to_string_8 (str_8)

			elseif attached {EL_ZSTRING} other as str_z then
				append_to (str_z)

			elseif attached {STRING_32} other as str_32 then
				append_to_string_32 (str_32)

			end
		end

	append_to_string_32 (other: STRING_32)
		local
			old_count: INTEGER; area_out: SPECIAL [CHARACTER_32]
		do
			old_count := other.count
			other.grow (old_count + count)
			area_out := other.area

			Codec.decode (count, area, area_out, old_count)
			write_unencoded (area_out, old_count, False)

			area_out [old_count + count] := '%U'
			other.set_count (old_count + count)
		end

	append_to_string_8 (other: STRING_8)
		local
			i, o_first_index, i_upper, block_index: INTEGER; already_latin_1: BOOLEAN
			c_i: CHARACTER; uc_i: CHARACTER_32; iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			other.grow (other.count + count)
			o_first_index := other.count
			i_upper := count - 1

			already_latin_1 := Codec.same_as (Latin_1_codec)

			if attached unicode_table as l_unicode_table and then attached unencoded_area as area_32
				and then attached other.area as o_area and then attached area as l_area
			then
				from i := area_lower until i > i_upper loop
					c_i := l_area [i]
					if c_i = Substitute then
						uc_i := iter.item ($block_index, area_32, i + 1)
						if uc_i.code <= Max_8_bit_code then
							o_area [o_first_index + i] := uc_i.to_character_8
						else
							o_area [o_first_index + i] := Substitute
						end
					elseif already_latin_1 or else c_i < Max_7_bit_character then
						o_area [o_first_index + i] := c_i
					else
						uc_i := l_unicode_table [c_i.code]
						if uc_i.code <= Max_8_bit_code then
							o_area [o_first_index + i] := uc_i.to_character_8
						else
							o_area [o_first_index + i] := Substitute
						end
					end
					i := i + 1
				end
			end
			other.set_count (other.count + count)
		end

	append_to_utf_8 (utf_8_out: STRING_8)
		do
			Utf_8_Codec.append_general_to_utf_8 (current_readable, utf_8_out)
		end

end