note
	description: "Measureable aspects of ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 7:07:19 GMT (Sunday 4th May 2025)"
	revision: "34"

deferred class
	EL_MEASUREABLE_ZSTRING

inherit
	EL_ZSTRING_BASE




feature -- Measurement

	leading_occurrences (uc: CHARACTER_32): INTEGER
		-- Returns count of continous occurrences of `uc' or white space starting from the begining
		local
			i, i_upper, block_index: INTEGER; encoded_c: CHARACTER
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			inspect uc.code
				when 0 .. Max_ascii_code then
					encoded_c := uc.to_character_8
			else
				encoded_c := Codec.encoded_character (uc)
			end
			i_upper := count - 1
			if attached area as l_area then
				if encoded_c = Substitute and then attached unencoded_area as area_32 and then area_32.count > 0 then
					from i := 0 until i > i_upper loop
						inspect l_area [i]
							when Substitute then
								Result := Result + (iter.item ($block_index, area_32, i + 1) = uc).to_integer
						else
							i := i_upper -- break out of loop
						end
						i := i + 1
					end
				else
					from i := 0 until i > i_upper loop
						-- `Unencoded_character' is space
						if l_area [i] = encoded_c then
							Result := Result + 1
						else
							i := i_upper -- break out of loop
						end
						i := i + 1
					end
				end
			end
		end

	leading_white_count: INTEGER
		-- count of leading white space characters
		do
			Result := internal_leading_white_space (area, 1, count)
		end

	leading_white_count_in_bounds (start_index, end_index: INTEGER): INTEGER
		-- count of leading white space characters between `start_index' and `end_index'
		require
			valid_bounds: valid_bounds (start_index, end_index)
		do
			Result := internal_leading_white_space (area, start_index, end_index)
		end

	occurrences (uc: CHARACTER_32): INTEGER
		local
			c: like area.item
		do
			inspect uc.code
				when 0 .. Max_ascii_code then
					c := uc.to_character_8
			else
				c := Codec.encoded_character (uc)
			end
			if c = Substitute then
				Result := unencoded_occurrences (uc)
			else
				Result := String_8.occurrences (Current, c)
			end
		end

	substitution_marker_count: INTEGER
		-- count of unescaped template substitution markers '%S' AKA '#'
		local
			index, escaped_count, i: INTEGER
		do
			if attached substitution_marker_index_list.area as marker_area then
				from until i = marker_area.count loop
					index := marker_area [i]
					if index - 1 > 0 and then item_8 (index - 1) = '%%' then
						escaped_count := escaped_count + 1
					end
					i := i + 1
				end
				Result := marker_area.count - escaped_count
			end
		end

	trailing_occurrences (uc: CHARACTER_32): INTEGER
		-- Returns count of continous occurrences of `uc' or white space starting from the end
		local
			i, block_index: INTEGER; encoded_c: CHARACTER
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
		do
			inspect uc.code
				when 0 .. Max_ascii_code then
					encoded_c := uc.to_character_8
			else
				encoded_c := Codec.encoded_character (uc)
			end
			if attached area as l_area then
				if encoded_c = Substitute then
					if attached unencoded_area as area_32 and then area_32.count > 0 then
						from i := count - 1 until i < 0 loop
							inspect l_area [i]
								when Substitute then
									Result := Result + (iter.item ($block_index, area_32, i + 1) = uc).to_integer
							else
								i := 0 -- break out of loop
							end
							i := i - 1
						end
					end
				else
					from i := count - 1 until i < 0 loop
						-- `Unencoded_character' is space
						if l_area [i] = encoded_c then
							Result := Result + 1
						else
							i := 0 -- break out of loop
						end
						i := i - 1
					end
				end
			end
		end

	trailing_white_count: INTEGER
		do
			Result := internal_trailing_white_space (area, 1, count)
		end

	trailing_white_count_in_bounds (start_index, end_index: INTEGER): INTEGER
		-- count of leading white space characters between `start_index' and `end_index'
		require
			valid_bounds: valid_bounds (start_index, end_index)
		do
			Result := internal_trailing_white_space (area, start_index, end_index)
		end

	utf_8_byte_count: INTEGER
		do
			Result := Codec.utf_8_byte_count (area, count) + unencoded_utf_8_byte_count
		end

feature {NONE} -- Implementation

	internal_leading_white_space (a_area: like area; start_index, end_index: INTEGER): INTEGER
		local
			c32: EL_CHARACTER_32_ROUTINES; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
			block_index, i, i_upper: INTEGER; c_i: CHARACTER
		do
			-- `Substitute' is space
			i_upper := end_index - 1

			if attached unencoded_area as area_32 and then attached Unicode_table as uc_table then
				from i := start_index - 1 until i > i_upper loop
					c_i := a_area [i]
					inspect character_8_band (c_i)
						when Substitute then
							if c32.is_space (iter.item ($block_index, area_32, i + 1)) then
								Result := Result + 1
							else
								i := i_upper -- break out of loop
							end
						when Ascii_range then
							if c_i.is_space then
								Result := Result + 1
							else
								i := i_upper -- break out of loop
							end
					else
						if c32.is_space (uc_table [c_i.code]) then
							Result := Result + 1
						else
							i := i_upper -- break out of loop
						end
					end
					i := i + 1
				end
			end
		ensure then
			substring_agrees: substring (start_index, start_index + Result - 1).is_space_filled
		end

	internal_trailing_white_space (a_area: like area; start_index, end_index: INTEGER): INTEGER
		local
			c32: EL_CHARACTER_32_ROUTINES; iter: EL_COMPACT_SUBSTRINGS_32_ITERATION
			block_index, i, i_lower: INTEGER; c_i: CHARACTER
		do
			-- `Substitute' is space
			i_lower := start_index - 1
			if attached unencoded_area as area_32 and then attached Unicode_table as uc_table then
				from i := end_index - 1 until i < i_lower loop
					c_i := a_area [i]
					inspect character_8_band (c_i)
						when Substitute then
							if c32.is_space (iter.item ($block_index, area_32, i + 1)) then
								Result := Result + 1
							else
								i := 0 -- break out of loop
							end
						when Ascii_range then
							if c_i.is_space then
								Result := Result + 1
							else
								i := 0 -- break out of loop
							end
					else
						if c32.is_space (uc_table [c_i.code]) then
							Result := Result + 1
						else
							i := 0 -- break out of loop
						end
					end
					i := i - 1
				end
			end
		ensure then
			substring_agrees: substring (end_index - Result + 1, end_index).is_space_filled
		end

end