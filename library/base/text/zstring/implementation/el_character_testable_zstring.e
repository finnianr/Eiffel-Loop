note
	description: "[
		Implementation of status queries for ${EL_READABLE_ZSTRING} related to presence of
		specified character sets for whole string or substring.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-31 10:08:51 GMT (Sunday 31st March 2024)"
	revision: "1"

deferred class
	EL_CHARACTER_TESTABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_READABLE_ZSTRING_I

feature -- Substring query

	ends_with_character (uc: CHARACTER_32): BOOLEAN
		-- `True' if last character in string is same as `uc'
		local
			i: INTEGER
		do
			i := count
			if i > 0 then
				if uc.natural_32_code <= 0x7F then
				-- ASCII
					Result := area [i - 1] = uc.to_character_8
				else
					Result := item (i) = uc
				end
			end
		end

	has_between (uc: CHARACTER_32; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `uc' occurs between `start_index' and `end_index'
		require
			valid_substring_indices: valid_substring_indices (start_index, end_index)
		local
			i: INTEGER; c: CHARACTER
		do
			c := codec.encoded_character (uc)
			inspect c
				when Substitute then
					Result := unencoded_has_between (uc, start_index, end_index)
			else
				if attached area as l_area then
					from i := start_index - 1 until i = end_index or Result loop
						Result := l_area [i] = c
						i := i + 1
					end
				end
			end
		end

	has_enclosing (c_first, c_last: CHARACTER_32): BOOLEAN
			--
		local
			uc_at_position: CHARACTER_32; i, position: INTEGER; c_i: CHARACTER
		do
			inspect count
				when 0, 1 then
					do_nothing
			else
				if attached area as l_area then
					Result := True
					from position := 1 until not Result or position > 2 loop
						inspect position
							when 1 then
								uc_at_position := c_first; i := 0
							when 2 then
								uc_at_position := c_last; i := count - 1
						end
						c_i := l_area [i]
						inspect c_i
							when Substitute then
								Result := unencoded_item (i + 1) = uc_at_position

							when Control_0 .. Control_25, Control_27 .. Max_ascii then
								Result := c_i = uc_at_position
						else
							Result :=  Codec.unicode_table [c_i.code] = uc_at_position
						end
						position := position + 1
					end
				end
			end
		end

	has_first (uc: CHARACTER_32): BOOLEAN
		-- `True' if first character in string is same as `uc'
		do
			Result := count > 0 and then item (1) = uc
		end

	has_quotes (a_count: INTEGER): BOOLEAN
		require
			double_or_single: 1 <= a_count and a_count <= 2
		local
			qmark: CHARACTER_32
		do
			inspect a_count
				when 1 then
					qmark := '%''
				when 2 then
					qmark := '"'
			else
			end
			Result := has_enclosing (qmark, qmark)
		end

	has_substring_only (set: EL_SET [CHARACTER_32]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `Current' only contains characters in `set'
		require
			valid_substring_indices: valid_substring_indices (start_index, end_index)
		local
			i, upper_index, block_index: INTEGER; c_i: CHARACTER_8; uc_i: CHARACTER_32
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			upper_index := count - 1
			if attached unicode_table as l_unicode_table and then attached area as l_area
				and then attached unencoded_area as area_32
			then
				Result := True
				from i := start_index - 1 until i > upper_index or not Result loop
					c_i := l_area [i]
					inspect c_i
						when Substitute then
							uc_i:= iter.item ($block_index, area_32, i + 1)

						when Control_0 .. Control_25, Control_27 .. Max_ascii then
							uc_i := c_i
					else
						uc_i := l_unicode_table [c_i.code]
					end
					if not set.has (uc_i) then
						Result := False
					end
					i := i + 1
				end
			end
		end

	has_substring_only_8 (set: EL_SET [CHARACTER_8]; start_index, end_index: INTEGER): BOOLEAN
		-- `True' if `Current' only contains encoded characters in `set'
		-- (encoded with same `Codec')
		require
			valid_substring_indices: valid_substring_indices (start_index, end_index)
			substitute_not_in_set: not set.has ((26).to_character_8)
		local
			i, upper_index: INTEGER; c_i: CHARACTER_8
		do

			if not has_mixed_encoding and then attached area as l_area then
				Result := True; upper_index := count - 1
				from i := start_index - 1 until i > upper_index or not Result loop
					c_i := l_area [i]
					inspect c_i
						when Substitute then
							Result := False
					else
						if not set.has (c_i) then
							Result := False
						end
					end
					i := i + 1
				end
			end
		end

	is_substring_whitespace (start_index, end_index: INTEGER): BOOLEAN
		require
			valid_substring_indices: valid_substring_indices (start_index, end_index)
		local
			i, block_index: INTEGER; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
			c32: EL_CHARACTER_32_ROUTINES; c_i: CHARACTER
		do
			if attached area as l_area and then attached unencoded_area as area_32 then
				if end_index = start_index - 1 then
					Result := False
				else
					Result := True
					from i := start_index - 1 until i = end_index or not Result loop
						c_i := l_area [i]
						inspect c_i
							when Substitute then
							-- `c32.is_space' is workaround for finalization bug
								Result := Result and c32.is_space (iter.item ($block_index, area_32, i + 1))
						else
							Result := Result and c_i.is_space
						end
						i := i + 1
					end
				end
			end
		end

	starts_with_character (uc: CHARACTER_32): BOOLEAN
		-- `True' if last character in string is same as `uc'
		do
			if count > 0 then
				if uc.natural_32_code <= 0x7F then
				-- ASCII
					Result := area [0] = uc.to_character_8
				else
					Result := item (1) = uc
				end
			end
		end

feature -- Indexed query

	is_alpha_item (i: INTEGER): BOOLEAN
		require
			valid_index: valid_index (i)
		local
			c_i: CHARACTER
		do
			c_i := area [i - 1]
			inspect c_i
				when Substitute then
					Result := unencoded_item (i).is_alpha

				when Control_0 .. Control_25, Control_27 .. Max_ascii then
					Result := c_i.is_alpha
			else
				Result := Codec.is_alpha (c_i.natural_32_code)
			end
		end

	is_alpha_numeric_item (i: INTEGER): BOOLEAN
		require else
			valid_index: valid_index (i)
		local
			c_i: CHARACTER
		do
			if attached area as c then
				c_i := area [i - 1]
				inspect c_i
					when Substitute then
						Result := unencoded_item (i).is_alpha_numeric

					when Control_0 .. Control_25, Control_27 .. Max_ascii then
						Result := c_i.is_alpha_numeric
				else
					Result := Codec.is_alphanumeric (c_i.natural_32_code)
				end
			end
		end

	is_numeric_item (i: INTEGER): BOOLEAN
		require
			valid_index: valid_index (i)
		local
			c32: EL_CHARACTER_32_ROUTINES; c_i: CHARACTER
		do
			if attached area as c then
				c_i := area [i - 1]
				inspect c_i
					when Substitute then
						Result := c32.is_digit (unencoded_item (i))
					when Control_0 .. Control_25, Control_27 .. Max_ascii then
						Result := c_i.is_digit
				else
					Result := Codec.is_numeric (c_i.natural_32_code)
				end
			end
		end

	is_space_item (i: INTEGER): BOOLEAN
		require
			valid_index: valid_index (i)
		local
			c_i: CHARACTER; c32: EL_CHARACTER_32_ROUTINES
		do
			c_i := area [i - 1]
			inspect c_i
				when Substitute then
				-- Because of a compiler bug we need `is_space_32'
					Result := c32.is_space (unencoded_item (i))
			else
				Result := c_i.is_space
			end
		end

feature -- Presence query

	has_alpha_numeric: BOOLEAN
		-- `True' if `str' has an alpha numeric character
		local
			i, block_index, i_final: INTEGER; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
			c_i: CHARACTER
		do
			if attached unencoded_area as area_32 and then attached area as l_area
				and then attached Codec as l_codec
			then
				i_final := count
				from i := 0 until Result or else i = i_final loop
					c_i := l_area [i]
					inspect c_i
						when Substitute then
							Result := iter.item ($block_index, area_32, i + 1).is_alpha_numeric
						when Control_0 .. Control_25, Control_27 .. Max_ascii then
							Result := c_i.is_alpha_numeric
					else
						Result := l_codec.is_alphanumeric (c_i.natural_32_code)
					end
					i := i + 1
				end
			end
		end

	has_only (set: EL_SET [CHARACTER_32]): BOOLEAN
		-- `True' if `Current' only contains characters in `set'
		do
			Result := has_substring_only (set, 1, count)
		end

	has_only_8 (set: EL_SET [CHARACTER_8]): BOOLEAN
		-- `True' if `Current' only contains encoded characters in `set'
		-- (encoded with same `Codec')
		do
			Result := has_substring_only_8 (set, 1, count)
		end

	has_unicode (uc: like unicode): BOOLEAN
		do
			Result := has_z_code (unicode_to_z_code (uc))
		end

feature -- All character query

	for_all (start_index, end_index: INTEGER; condition: PREDICATE [CHARACTER_32]): BOOLEAN
		-- True if `condition' is true for all characters in range `start_index' .. `end_index'
		-- (when testing for whitespace, use `is_substring_whitespace', it's more efficient)
		require
			start_index_big_enough: 1 <= start_index
			end_index_small_enough: end_index <= count
			consistent_indexes: start_index - 1 <= end_index
		local
			i, block_index: INTEGER; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
			c_i: CHARACTER
		do
			if attached area as l_area and then attached unencoded_area as area_32 then
				Result := True

				from i := start_index - 1 until not Result or else i = end_index loop
					c_i := l_area [i]
					inspect c_i
						when Substitute then
							Result := Result and condition (iter.item ($block_index, area_32, i + 1))
						when Control_0 .. Control_25, Control_27 .. Max_ascii then
							Result := Result and condition (c_i.to_character_32)
					else
						Result := Result and condition (Unicode_table [c_i.code])
					end
					i := i + 1
				end
			end
		end

	is_character (uc: CHARACTER_32): BOOLEAN
		-- `True' if string is same as single character `uc'
		do
			Result := count = 1 and then item (1) = uc
		end

	is_code_identifier: BOOLEAN
		-- is C, Eiffel or other language identifier
		local
			i, l_count: INTEGER
		do
			if attached area as l_area then
				l_count := count; Result := True

				from i := 0 until not Result or else i = l_count loop
					inspect l_area [i]
						when 'a' .. 'z', 'A' .. 'Z' then
						--	do nothing

						when '0' .. '9', '_' then
							Result := i > 0
					else
						Result := False
					end
					i := i + 1
				end
			end
		end

	is_space_filled: BOOLEAN
		do
			inspect count
				when 0 then
					Result := True
			else
				Result := is_substring_whitespace (1, count)
			end
		end

	is_valid_as_string_8: BOOLEAN
		do
			Result := Latin_1_codec.is_encodeable_as_string_8 (current_readable, 1, count)
		end

end