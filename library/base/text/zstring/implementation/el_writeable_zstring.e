note
	description: "Writing contents of ${ZSTRING} to external strings/objects"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-09 16:46:18 GMT (Tuesday 9th April 2024)"
	revision: "23"

deferred class
	EL_WRITEABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

feature -- Write to other

	write_latin (writeable: EL_WRITABLE)
		-- write `area' sequence as raw characters to `writeable'
		local
			i, l_count: INTEGER; l_area: like area
		do
			l_area := area; l_count := count
			from i := 0 until i = l_count loop
				writeable.write_encoded_character_8 (l_area [i])
				i := i + 1
			end
		end

feature -- Append to other

	append_to (other: EL_ZSTRING)
		do
			other.append (current_readable)
		end

	append_to_general (general: STRING_GENERAL)
		do
			if general.is_string_8 then
				if attached {STRING_8} general as other_8 then
					append_to_string_8 (other_8)
				end

			elseif same_type (general) and then attached {ZSTRING} general as z_str then
				z_str.append (current_readable)

			else
				if attached {STRING_32} general as other_32 then
					append_to_string_32 (other_32)
				end
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
			write_unencoded (area_out, old_count, count, False)

			area_out [old_count + count] := '%U'
			other.set_count (old_count + count)
		end

	append_to_string_8 (other: STRING_8)
		local
			i, o_first_index, i_upper, block_index: INTEGER; already_latin_1: BOOLEAN
			c_i: CHARACTER; uc_i: CHARACTER_32; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			other.grow (other.count + count)
			o_first_index := other.count
			i_upper := count - 1

			already_latin_1 := Codec.encoded_as_latin (1)

			if already_latin_1 and then not has_mixed_encoding then
				other.area.copy_data (area, 0, o_first_index, count)

			elseif attached unicode_table as l_unicode_table and then attached unencoded_area as area_32
				and then attached other.area as o_area and then attached area as l_area
			then
				from i := area_lower until i > i_upper loop
					c_i := l_area [i]
					inspect c_i
						when Substitute then
							uc_i := iter.item ($block_index, area_32, i + 1)
							if uc_i.code <= Max_8_bit_code then
								o_area [o_first_index + i] := uc_i.to_character_8
							else
								o_area [o_first_index + i] := Substitute
							end
						when Control_0 .. Control_25, Control_27 .. Max_ascii then
							o_area [o_first_index + i] := c_i
					else
						if already_latin_1 then
							o_area [o_first_index + i] := c_i
						else
							uc_i := l_unicode_table [c_i.code]
							if uc_i.code <= Max_8_bit_code then
								o_area [o_first_index + i] := uc_i.to_character_8
							else
								o_area [o_first_index + i] := Substitute
							end
						end
					end
					i := i + 1
				end
			end
			other.set_count (other.count + count)
		end

	append_to_utf_8 (a_utf_8: STRING_8)
		local
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION; sequence: like Utf_8_sequence
			i, i_upper, block_index, offset, ascii_count: INTEGER; c_i: CHARACTER
		do
			sequence := Utf_8_sequence
			a_utf_8.grow (a_utf_8.count + utf_8_byte_count)

			ascii_count := leading_ascii_count (area, area_lower, area_upper)
			if ascii_count > 0 then
				offset := a_utf_8.count
				a_utf_8.area.copy_data (area, area_lower, offset, ascii_count)
				a_utf_8.area [ascii_count + offset] := '%U'
				a_utf_8.set_count (a_utf_8.count + ascii_count)
			end
			if ascii_count < count and then attached area as l_area
				and then attached codec as l_codec and then attached unencoded_area as area_32
			then
				i_upper := area_upper
				from i := area_lower + ascii_count until i > i_upper loop
					c_i := l_area [i]
					inspect c_i
						when Substitute then
							sequence.set (iter.item ($block_index, area_32, i + 1))
							sequence.append_to_string (a_utf_8)
						when Control_0 .. Control_25, Control_27 .. Max_ascii then
							a_utf_8.extend (c_i)
					else
						sequence.set (l_codec.unicode_table [c_i.code])
						sequence.append_to_string (a_utf_8)
					end
					i := i + 1
				end
			end
		ensure
			size_agrees: utf_8_byte_count = (a_utf_8.count - old a_utf_8.count)
		end

feature -- Basic operations

	fill_with_z_code (str: STRING_32)
		-- fill `str' with z_code characters
		local
			i, l_count, block_index: INTEGER; c_i: CHARACTER; z_code_i: NATURAL
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			l_count := count
			str.grow (l_count)
			str.set_count (l_count)
			if attached str.area as str_area_32 and then attached area as l_area
				and then attached unencoded_area as area_32
			then
				from i := 0 until i = l_count loop
					c_i := l_area [i]
					inspect c_i
						when Substitute then
							z_code_i := unicode_to_z_code (iter.code ($block_index, area_32, i + 1))
							str_area_32 [i] := z_code_i.to_character_32
					else
						str_area_32 [i] := c_i
					end
					i := i + 1
				end
				str_area_32 [i] := '%U'
			end
		end

end