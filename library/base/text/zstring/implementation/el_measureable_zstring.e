note
	description: "Measureable aspects of [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-10 15:18:13 GMT (Friday 10th November 2023)"
	revision: "21"

deferred class
	EL_MEASUREABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

	EL_READABLE_ZSTRING_I

feature -- Measurement

	leading_occurrences (uc: CHARACTER_32): INTEGER
		-- Returns count of continous occurrences of `uc' or white space starting from the begining
		local
			i, l_count, block_index: INTEGER; l_area: like area; c: CHARACTER
			iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			if uc.code <= Max_7_bit_code then
				c := uc.to_character_8
			else
				c := Codec.encoded_character (uc)
			end
			l_area := area; l_count := count
			if c = Substitute and then attached unencoded_area as area_32 and then area_32.count > 0 then
				from i := 0 until i = l_count loop
					if l_area [i] = Substitute and then iter.item ($block_index, area_32, i + 1) = uc then
						Result := Result + 1
					else
						i := l_count - 1 -- break out of loop
					end
					i := i + 1
				end
			else
				from i := 0 until i = l_count loop
					-- `Unencoded_character' is space
					if l_area [i] = c then
						Result := Result + 1
					else
						i := l_count - 1 -- break out of loop
					end
					i := i + 1
				end
			end
		ensure
			substring_agrees: substring (1, Result).occurrences (uc) = Result
		end

	leading_white_space: INTEGER
		do
			Result := internal_leading_white_space (area, count)
		end

	occurrences (uc: CHARACTER_32): INTEGER
		local
			c: like area.item
		do
			if uc.code <= Max_7_bit_code then
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
			index: INTEGER; escape_code: NATURAL
		do
			if attached internal_substring_index_list (Substitution_marker) as list then
				escape_code := ('%%').natural_32_code
				from list.start until list.after loop
					index := list.item
					if index > 1 and then z_code (index - 1) = escape_code then
						list.remove
					else
						list.forth
					end
				end
				Result := list.count
			end
		end

	trailing_occurrences (uc: CHARACTER_32): INTEGER
			-- Returns count of continous occurrences of `uc' or white space starting from the end
		local
			i, block_index: INTEGER; l_area: like area; c, c_i: CHARACTER
			iter: EL_UNENCODED_CHARACTER_ITERATION
		do
			if uc.code <= Max_7_bit_code then
				c := uc.to_character_8
			else
				c := Codec.encoded_character (uc)
			end
			l_area := area
			if c = Substitute then
				if attached unencoded_area as area_32 and then area_32.count > 0 then
					from i := count - 1 until i < 0 loop
						c_i := l_area [i]
						if c_i = Substitute and then iter.item ($block_index, area_32, i + 1) = uc then
							Result := Result + 1
						else
							i := 0 -- break out of loop
						end
						i := i - 1
					end
				end
			else
				from i := count - 1 until i < 0 loop
					c_i := l_area [i]
					-- `Unencoded_character' is space
					if c_i = c then
						Result := Result + 1
					else
						i := 0 -- break out of loop
					end
					i := i - 1
				end
			end
		ensure
			substring_agrees: substring (count - Result + 1, count).occurrences (uc) = Result
		end

	trailing_white_space: INTEGER
		do
			Result := internal_trailing_white_space (area)
		end

	utf_8_byte_count: INTEGER
		do
			Result := Codec.utf_8_byte_count (area, count) + unencoded_utf_8_byte_count
		end

feature {NONE} -- Implementation

	internal_leading_white_space (a_area: like area; a_count: INTEGER): INTEGER
		local
			c: EL_CHARACTER_32_ROUTINES; iter: EL_UNENCODED_CHARACTER_ITERATION
			block_index, i: INTEGER; c_i: CHARACTER
		do
			if attached unencoded_area as area_32 and then area_32.count > 0 then
				from i := 0 until i = a_count loop
					c_i := a_area [i]
					-- `Unencoded_character' is space
					if c_i.is_space then
						Result := Result + 1

					elseif c_i = Substitute then
						if c.is_space (iter.item ($block_index, area_32, i + 1)) then
							Result := Result + 1
						else
							i := a_count - 1 -- break out of loop
						end
					else
						i := a_count - 1 -- break out of loop
					end
					i := i + 1
				end
			else
				from i := 0 until i = a_count loop
					if a_area.item (i).is_space then
						Result := Result + 1
					else
						i := a_count - 1 -- break out of loop
					end
					i := i + 1
				end
			end
		ensure then
			substring_agrees: substring (1, Result).is_space_filled
		end

	internal_trailing_white_space (a_area: like area): INTEGER
		local
			c: EL_CHARACTER_32_ROUTINES; iter: EL_UNENCODED_CHARACTER_ITERATION
			block_index, i: INTEGER; c_i: CHARACTER
		do
			if attached unencoded_area as area_32 and then area_32.count > 0 then
				from i := count - 1 until i < 0 loop
					c_i := a_area [i]
					-- `Unencoded_character' is space
					if c_i.is_space then
						Result := Result + 1

					elseif c_i = Substitute then
						if c.is_space (iter.item ($block_index, area_32, i + 1)) then
							Result := Result + 1
						else
							i := 0 -- break out of loop
						end
					else
						i := 0 -- break out of loop
					end
					i := i - 1
				end
			else
				from i := count - 1 until i < 0 loop
					-- `Unencoded_character' is space
					if a_area.item (i).is_space then
						Result := Result + 1
					else
						i := 0 -- break out of loop
					end
					i := i - 1
				end
			end
		end

feature -- Constants

	Substitution_marker: EL_ZSTRING
		once
			Result := "%S"
		end

end