note
	description: "[
		Interface to classes [$source EL_STRING_8_ITERATION_CURSOR] and [$source EL_STRING_32_ITERATION_CURSOR]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-13 19:03:10 GMT (Monday 13th November 2023)"
	revision: "13"

deferred class
	EL_STRING_ITERATION_CURSOR

inherit
	EL_ZCODE_CONVERSION

	EL_SHARED_ZSTRING_CODEC

	STRING_HANDLER

	EL_BIT_COUNTABLE

	EL_UC_ROUTINES
		rename
			utf_8_byte_count as utf_8_character_byte_count
		end

	EL_SHARED_UTF_8_SEQUENCE

feature {NONE} -- Initialization

	make (t: like target)
		deferred
		end

	make_empty
		do
			make (empty_target)
		end

feature -- Element change

	set_target (a_target: like target)
		deferred
		end

feature -- Basic operations

	append_to (destination: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		require
			enough_space: n <= destination.capacity - destination.count
		deferred
		end

	append_to_string_8 (str: STRING_8)
		require
			valid_as_string_8: is_valid_as_string_8
		local
			i, last_i, first_i, l_count, offset: INTEGER; code: NATURAL
		do
			l_count := target.count
			if l_count > 0 then
				offset := str.count
				str.grow (offset + l_count)
				str.set_count (offset + l_count)

				first_i := area_first_index; last_i := area_last_index
				if attached str.area as str_area and then attached area as l_area then
					from i := first_i until i > last_i loop
						str_area [offset] := i_th_character_8 (l_area, i)
						offset := offset + 1
						i := i + 1
					end
				end
			end
		ensure
			correct_size: str.count = old str.count + target.count
			substring_appended: str.ends_with_general (target)
		end

	append_to_utf_8 (utf_8: STRING_8)
		local
			i, last_i: INTEGER; uc: CHARACTER_32
		do
			last_i := area_last_index
			if attached area as l_area and then attached Utf_8_sequence as sequence then
				from i := area_first_index until i > last_i loop
					uc := i_th_character_32 (l_area, i)
					if uc.natural_32_code <= 0x7F then
						utf_8.append_character (uc.to_character_8)
					else
						sequence.set (uc)
						sequence.append_to_string (utf_8)
					end
					i := i + 1
				end
			end
		end

	append_substring_to_string_8 (str: STRING_8; start_index, end_index: INTEGER)
		require
			valid_start_end_index: start_index + 1 <= end_index
			valid_start: valid_index (start_index)
			valid_end: end_index > 0 implies valid_index (end_index)
		local
			i, last_i, first_i, l_count, offset: INTEGER; l_area: like area; code: NATURAL
		do
			l_count := end_index - start_index + 1
			if l_count > 0 then
				offset := str.count
				str.grow (offset + l_count)
				str.set_count (offset + l_count)

				first_i := area_first_index + start_index - 1
				last_i := first_i + l_count - 1; l_area := area
				if attached str.area as str_area then
					from i := first_i until i > last_i loop
						str_area [offset] := i_th_character_8 (l_area, i)
						offset := offset + 1
						i := i + 1
					end
				end
			end
		ensure
			correct_size: str.count - old str.count = end_index - start_index + 1
			substring_appended: str.ends_with_general (target.substring (start_index, end_index))
		end

	append_substring_to_string_32 (str: STRING_32; start_index, end_index: INTEGER)
		require
			valid_start_end_index: start_index + 1 <= end_index
			valid_start: valid_index (start_index)
			valid_end: end_index > 0 implies valid_index (end_index)
		local
			i, last_i, first_i, l_count, offset: INTEGER; l_area: like area; code: NATURAL
		do
			l_count := end_index - start_index + 1
			if l_count > 0 then
				offset := str.count
				str.grow (offset + l_count)
				str.set_count (offset + l_count)

				first_i := area_first_index + start_index - 1
				last_i := first_i + l_count - 1; l_area := area
				if attached str.area as str_area then
					from i := first_i until i > last_i loop
						str_area [offset] := i_th_character_32 (l_area, i)
						offset := offset + 1
						i := i + 1
					end
				end
			end
		ensure
			correct_size: str.count - old str.count = end_index - start_index + 1
			substring_appended: str.ends_with_general (target.substring (start_index, end_index))
		end

	fill_z_codes (destination: SPECIAL [CHARACTER_32])
		-- fill destination with z_codes
		require
			valid_size: destination.count >= target_count + 1
		local
			i, i_final: INTEGER; code: NATURAL
		do
			if attached area as l_area and then attached codec as l_codec then
				i_final := target_count
				from i := 0 until i = i_final loop
					code := l_codec.as_z_code (i_th_character_32 (l_area, i + area_first_index))
					destination [i] := code.to_character_32
					i := i + 1
				end
				destination [i] := '%U'
			end
		end

	parse (convertor: STRING_TO_NUMERIC_CONVERTOR; type: INTEGER)
		local
			i, last_i: INTEGER; l_area: like area; c: CHARACTER; failed: BOOLEAN
		do
			convertor.reset (type)
			last_i := area_last_index; l_area := area
			from i := area_first_index until i > last_i or failed loop
				c := i_th_ascii_character (l_area, i)
				if c.natural_32_code > 0 then
					convertor.parse_character (c)
					failed := not convertor.parse_successful
				else
					failed := True
				end
				i := i + 1
			end
		end

feature -- Status query

	all_ascii: BOOLEAN
		deferred
		end

	has_character_in_bounds (uc: CHARACTER_32; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `uc' occurrs between `start_index' and `end_index'
		require
			valid_start_index: valid_index (start_index)
			valid_end_index: end_index >= start_index and end_index <= target_count
		deferred
		end

	is_eiffel: BOOLEAN
		-- `True' if `target' is an Eiffel identifier
		do
			Result := is_area_eiffel_identifier ({EL_CASE}.Lower | {EL_CASE}.Upper)
		end

	is_eiffel_lower: BOOLEAN
		-- `True' if `target' is a lower-case Eiffel identifier
		do
			Result := is_area_eiffel_identifier ({EL_CASE}.Lower)
		end

	is_eiffel_title: BOOLEAN
		-- `True' if `target' is an title-case Eiffel identifier
		do
			Result := is_area_eiffel_identifier ({EL_CASE}.Title | {EL_CASE}.Lower)
		end

	is_eiffel_upper: BOOLEAN
		-- `True' if `target' is an upper-case Eiffel identifier
		do
			Result := is_area_eiffel_identifier ({EL_CASE}.Upper)
		end

	is_valid_as_string_8: BOOLEAN
		do
			Result := target.is_valid_as_string_8
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := target.valid_index (i)
		end

feature -- Measurement

	latin_1_count: INTEGER
		deferred
		end

	leading_occurrences (uc: CHARACTER_32): INTEGER
		deferred
		end

	leading_white_count: INTEGER
		deferred
		end

	target_count: INTEGER
		deferred
		end

	trailing_white_count: INTEGER
		deferred
		end

	utf_8_byte_count: INTEGER
		local
			i, last_i: INTEGER; l_area: like area; code: NATURAL
		do
			last_i := area_last_index; l_area := area
			from i := area_first_index until i > last_i loop
				code := i_th_unicode (l_area, i)
				Result := Result + utf_8_character_byte_count (code)
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	is_area_eiffel_identifier (case_code: NATURAL): BOOLEAN
		local
			first_i: BOOLEAN; i, last_i: INTEGER; l_area: like area
		do
			last_i := area_last_index; l_area := area
			Result := target_count > 0; first_i := True
			from i := area_first_index until i > last_i or not Result loop
				Result := is_i_th_eiffel_identifier (l_area, i, case_code, first_i)
				if first_i then
					first_i := False
				end
				i := i + 1
			end
		end

feature {STRING_HANDLER} -- Deferred

	area: SPECIAL [ANY]
		deferred
		end

	area_first_index: INTEGER
		deferred
		end

	area_last_index: INTEGER
		deferred
		end

	empty_target: like target
		deferred
		end

	i_th_ascii_character (a_area: like area; i: INTEGER): CHARACTER_8
		deferred
		end

	i_th_character_8 (a_area: like area; i: INTEGER): CHARACTER_8
		deferred
		end

	i_th_character_32 (a_area: like area; i: INTEGER): CHARACTER_32
		deferred
		end

	i_th_unicode (a_area: like area; i: INTEGER): NATURAL
		deferred
		end

	is_i_th_eiffel_identifier (a_area: like area; i: INTEGER; case_code: NATURAL; first_i: BOOLEAN): BOOLEAN
		deferred
		end

	target: READABLE_STRING_GENERAL
		deferred
		end

end