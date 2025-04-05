note
	description: "[
		Interface to classes ${EL_STRING_8_ITERATION_CURSOR} and ${EL_STRING_32_ITERATION_CURSOR}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-03 17:46:18 GMT (Thursday 3rd April 2025)"
	revision: "33"

deferred class
	EL_STRING_ITERATION_CURSOR

inherit
	EL_ZCODE_CONVERSION

	EL_STRING_HANDLER

	EL_BIT_COUNTABLE

	EL_UC_ROUTINES
		rename
			utf_8_byte_count as utf_8_character_byte_count
		export
			{NONE} all
		end

	EL_SHARED_UTF_8_SEQUENCE; EL_SHARED_ZSTRING_CODEC

feature {NONE} -- Initialization

	make (t: like target)
		do
			set_target (t)
		end

	make_empty
		do
			set_target (empty_target)
		end

feature -- Element change

	set_target (a_target: like target)
		deferred
		end

feature -- Conversion

	to_utf_8: STRING
		do
			create Result.make (utf_8_byte_count)
			append_to_utf_8 (Result)
		end

feature -- Basic operations

	append_substring_to_string_32 (str: STRING_32; start_index, end_index: INTEGER)
		require
			valid_start_end_index: start_index <= end_index + 1
			valid_start: valid_index (start_index)
			valid_end: end_index > 0 implies valid_index (end_index)
		local
			i, i_upper, i_lower, l_count, offset: INTEGER; l_area: like area
		do
			l_count := end_index - start_index + 1
			if l_count > 0 then
				offset := str.count
				str.grow (offset + l_count)
				str.set_count (offset + l_count)

				i_lower := index_lower + start_index - 1
				i_upper := i_lower + l_count - 1; l_area := area
				if attached str.area as str_area then
					from i := i_lower until i > i_upper loop
						str_area [offset] := i_th_character_32 (l_area, i)
						offset := offset + 1
						i := i + 1
					end
				end
			end
		ensure
			correct_size: str.count - old str.count = end_index - start_index + 1
			substring_appended: ends_with_target_substring (str, start_index, old str.count + 1)
		end

	append_substring_to_string_8 (str: STRING_8; start_index, end_index: INTEGER)
		require
			valid_start_end_index: start_index <= end_index + 1
			valid_start: valid_index (start_index)
			valid_end: end_index > 0 implies valid_index (end_index)
		local
			i, i_upper, i_lower, l_count, offset: INTEGER; l_area: like area
		do
			l_count := end_index - start_index + 1
			if l_count > 0 then
				offset := str.count
				str.grow (offset + l_count)
				str.set_count (offset + l_count)

				i_lower := index_lower + start_index - 1
				i_upper := i_lower + l_count - 1; l_area := area
				if attached str.area as str_area then
					from i := i_lower until i > i_upper loop
						str_area [offset] := i_th_character_8 (l_area, i)
						offset := offset + 1
						i := i + 1
					end
				end
			end
		ensure
			correct_size: str.count - old str.count = end_index - start_index + 1
			substring_appended: ends_with_target_substring (str, start_index, old str.count + 1)
		end

	append_to (destination: SPECIAL [CHARACTER_32]; source_index, n: INTEGER)
		require
			enough_space: n <= destination.capacity - destination.count
		deferred
		end

	append_to_string_8 (str: STRING_8)
		require
			valid_as_string_8: is_valid_as_string_8
		do
			append_substring_to_string_8 (str, 1, target.count)
		end

	append_to_utf_8 (utf_8_out: STRING_8)
		local
			i, i_upper: INTEGER; code_i: NATURAL
		do
			utf_8_out.grow (utf_8_out.count + utf_8_byte_count)
			i_upper := index_upper
			if attached area as l_area and then attached Utf_8_sequence as utf_8 then
				from i := index_lower until i > i_upper loop
					code_i := i_th_character_32 (l_area, i).natural_32_code
					if code_i <= 0x7F then
						utf_8_out.append_character (code_i.to_character_8)
					else
						utf_8.set_area (code_i)
						utf_8.append_to_string (utf_8_out)
					end
					i := i + 1
				end
			end
		end

	fill_z_codes (destination: STRING_32)
		-- fill destination with z_codes
		local
			i, i_upper, j: INTEGER; code: NATURAL
		do
			destination.grow (target.count)
			destination.set_count (target.count)

			if attached destination.area as destination_area and then attached area as l_area
				and then attached codec as l_codec
			then
				i_upper := index_upper
				from i := index_lower until i > i_upper loop
					code := l_codec.as_z_code (i_th_character_32 (l_area, i))
					destination_area [j] := code.to_character_32
					i := i + 1; j := j +1
				end
				destination_area [j] := '%U'
			end
		end

	parse (convertor: STRING_TO_NUMERIC_CONVERTOR; type: INTEGER)
		do
			parse_substring (convertor, type, 1, target.count)
		end

	parse_substring (convertor: STRING_TO_NUMERIC_CONVERTOR; type, start_index, end_index: INTEGER)
		local
			i, i_upper, i_lower, l_count: INTEGER; failed: BOOLEAN; c: CHARACTER_8
		do
			l_count := end_index - start_index + 1
			convertor.reset (type)
			i_lower := index_lower + start_index - 1
			if attached area as l_area then
				i_upper := i_lower + l_count - 1
				from i := i_lower until i > i_upper or failed loop
					c := i_th_character_8 (l_area, i)
					inspect c
						when '0' .. '9', 'e', 'E', '.', '+', '-' then
							convertor.parse_character (c)
							if convertor.parse_successful then
								i := i + 1
							else
								failed := True
							end
					else
						convertor.reset (type); failed := True
					end
				end
			end
		end

	write_utf_8_to (utf_8_out: EL_WRITABLE)
		local
			i, i_upper: INTEGER; code_i: NATURAL
		do
			i_upper := index_upper
			if attached area as l_area and then attached Utf_8_sequence as utf_8 then
				from i := index_lower until i > i_upper loop
					code_i := i_th_unicode (l_area, i)
					if code_i <= 0x7F then
						utf_8_out.write_encoded_character_8 (code_i.to_character_8)
					else
						utf_8.set_area (code_i)
						utf_8.write (utf_8_out)
					end
					i := i + 1
				end
			end
		end

feature -- Status query

	all_alpha_numeric: BOOLEAN
		-- `True' if all characters in `target' are alphabetical or numerical
		deferred
		end

	all_ascii: BOOLEAN
		deferred
		end

	has_character_in_bounds (uc: CHARACTER_32; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `uc' occurs between `start_index' and `end_index'
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
			Result := is_area_eiffel_identifier ({EL_CASE}.Proper | {EL_CASE}.Lower)
		end

	is_eiffel_upper: BOOLEAN
		-- `True' if `target' is an upper-case Eiffel identifier
		do
			Result := is_area_eiffel_identifier ({EL_CASE}.Upper)
		end

	is_left_bracket_at (index: INTEGER): BOOLEAN
		require
			valid_index: valid_index (index)
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := c.is_left_bracket (i_th_character_8 (area, index_lower + index - 1))
		end

feature -- Contract Support

	ends_with_target (str: READABLE_STRING_GENERAL; index: INTEGER): BOOLEAN
		do
			Result := target.same_characters (str, index, str.count, 1)
		end

	ends_with_target_substring (str: READABLE_STRING_GENERAL; target_index, index: INTEGER): BOOLEAN
		do
			Result := target.same_characters (str, index, str.count, target_index)
		end

	is_valid_as_string_8: BOOLEAN
		do
			Result := target.is_valid_as_string_8
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := target.valid_index (i)
		end

feature -- Search

	matching_bracket_index (index: INTEGER): INTEGER
		require
			valid_index: valid_index (index)
			left_bracket_at_index: is_left_bracket_at (index)
		local
			i, i_upper, i_lower, nest_count: INTEGER; found: BOOLEAN
			left_bracket, right_bracket, c: CHARACTER; c8: EL_CHARACTER_8_ROUTINES
		do
			i_upper := index_upper
			i_lower := index_lower + index
			if attached area as l_area then
				left_bracket := i_th_character_8 (l_area, i_lower - 1)
				right_bracket := c8.right_bracket (left_bracket)
				from i := i_lower until found or i > i_upper loop
					c := i_th_character_8 (l_area, i)
					if c = left_bracket then
						nest_count := nest_count + 1
					else
						inspect nest_count
							when 0 then
								if c = right_bracket then
									found := True
								end
						else
							if c = right_bracket then
								nest_count := nest_count - 1
							end
						end
					end
					i := i + 1
				end
				if found then
					Result := i
				end
			end
		end

feature -- Measurement

	index_lower: INTEGER
		deferred
		end

	index_upper: INTEGER
		deferred
		end

	latin_1_count: INTEGER
		deferred
		end

	leading_occurrences (uc: CHARACTER_32): INTEGER
		deferred
		end

	leading_white_count: INTEGER
		deferred
		end

	occurrences_in_bounds (uc: CHARACTER_32; start_index, end_index: INTEGER): INTEGER
		-- `True' if `uc' occurs between `start_index' and `end_index'
		require
			valid_start_end_index: start_index <= end_index + 1
			valid_start: valid_index (start_index)
			valid_end: end_index > 0 implies valid_index (end_index)
		local
			i, i_upper, i_lower, l_count: INTEGER
		do
			l_count := end_index - start_index + 1
			if l_count > 0 and then attached area as l_area then
				i_lower := index_lower + start_index - 1
				i_upper := i_lower + l_count - 1
				from i := i_lower until i > i_upper loop
					if i_th_character_32 (l_area, i) = uc then
						Result := Result + 1
					end
					i := i + 1
				end
			end
		end

	target_count: INTEGER
		deferred
		end

	trailing_white_count: INTEGER
		deferred
		end

	utf_8_byte_count: INTEGER
		local
			i, i_upper: INTEGER; uc: NATURAL
		do
			i_upper := index_upper
			if attached area as l_area then
				from i := index_lower until i > i_upper loop
					uc := i_th_unicode (l_area, i)
					Result := Result + utf_8_character_byte_count (uc)
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	is_area_eiffel_identifier (case_code: NATURAL): BOOLEAN
		local
			i_lower: BOOLEAN; i, i_upper: INTEGER; l_area: like area
		do
			i_upper := index_upper; l_area := area
			Result := target_count > 0; i_lower := True
			from i := index_lower until i > i_upper or not Result loop
				Result := is_i_th_eiffel_identifier (l_area, i, case_code, i_lower)
				if i_lower then
					i_lower := False
				end
				i := i + 1
			end
		end

feature {STRING_HANDLER} -- Deferred

	area: SPECIAL [COMPARABLE]
		deferred
		end

	empty_target: like target
		deferred
		end

	i_th_character_32 (a_area: like area; i: INTEGER): CHARACTER_32
		deferred
		end

	i_th_character_8 (a_area: like area; i: INTEGER): CHARACTER_8
		deferred
		end

	i_th_unicode (a_area: like area; i: INTEGER): NATURAL
		deferred
		end

	is_i_th_eiffel_identifier (a_area: like area; i: INTEGER; case_code: NATURAL; i_lower: BOOLEAN): BOOLEAN
		deferred
		end

	target: READABLE_STRING_GENERAL
		deferred
		end

end