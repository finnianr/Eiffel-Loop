note
	description: "Measureable aspects of [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-31 16:58:05 GMT (Friday 31st December 2021)"
	revision: "8"

deferred class
	EL_MEASUREABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

feature -- Measurement

	Lower: INTEGER = 1

	leading_occurrences (uc: CHARACTER_32): INTEGER
			-- Returns count of continous occurrences of `uc' or white space starting from the begining
		local
			i, l_count: INTEGER; l_area: like area; c: CHARACTER; uc_code: NATURAL
			unencoded: like unencoded_indexable
		do
			c := encoded_character (uc); uc_code := uc.natural_32_code
			l_area := area; l_count := count
			if c /= Unencoded_character then
				from i := 0 until i = l_count loop
					-- `Unencoded_character' is space
					if l_area [i] = c then
						Result := Result + 1
					else
						i := l_count - 1 -- break out of loop
					end
					i := i + 1
				end
			elseif has_mixed_encoding then
				unencoded := unencoded_indexable
				from i := 0 until i = l_count loop
					if l_area [i] = Unencoded_character and then unencoded.code (i + 1) = uc_code then
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
		local
			i, l_count: INTEGER; l_area: like area; c_i: CHARACTER
			c: EL_CHARACTER_32_ROUTINES; unencoded: like unencoded_indexable
		do
			l_area := area; l_count := count
			if has_mixed_encoding then
				unencoded := unencoded_indexable
				from i := 0 until i = l_count loop
					c_i := l_area [i]
					-- `Unencoded_character' is space
					if c_i = Unencoded_character then
						if c.is_space (unencoded.item (i + 1)) then
							Result := Result + 1
						else
							i := l_count - 1 -- break out of loop
						end
					elseif c_i.is_space then
						Result := Result + 1
					else
						i := l_count - 1 -- break out of loop
					end
					i := i + 1
				end
			else
				from i := 0 until i = l_count loop
					if l_area.item (i).is_space then
						Result := Result + 1
					else
						i := l_count - 1 -- break out of loop
					end
					i := i + 1
				end
			end
		ensure then
			substring_agrees: across substring (1, Result) as uc all character_properties.is_space (uc.item) end
		end

	occurrences (uc: CHARACTER_32): INTEGER
		local
			c: like area.item
		do
			c := encoded_character (uc)
			if c = Unencoded_character then
				Result := unencoded_occurrences (uc.natural_32_code)
			else
				Result := internal_occurrences (c)
			end
		end

	substitution_marker_count: INTEGER
		-- count of unescaped template substitution markers '%S' AKA '#'
		local
			l_index_list: like substring_index_list
			index: INTEGER; escape_code: NATURAL
		do
			l_index_list := substring_index_list (Substitution_marker)
			escape_code := ('%%').natural_32_code
			from l_index_list.start until l_index_list.after loop
				index := l_index_list.item
				if index > 1 and then z_code (index - 1) = escape_code then
					l_index_list.remove
				else
					l_index_list.forth
				end
			end
			Result := l_index_list.count
		end

	trailing_occurrences (uc: CHARACTER_32): INTEGER
			-- Returns count of continous occurrences of `uc' or white space starting from the end
		local
			i: INTEGER; l_area: like area; c, c_i: CHARACTER
			unencoded: like unencoded_indexable; uc_code: NATURAL
		do
			c := encoded_character (uc); uc_code := uc.natural_32_code
			l_area := area; unencoded := unencoded_indexable
			if c = Unencoded_character then
				if has_mixed_encoding then
					from i := count - 1 until i < 0 loop
						c_i := l_area [i]
						if c_i = Unencoded_character and then unencoded.code (i + 1) = uc_code then
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
		local
			i: INTEGER; l_area: like area; c_i: CHARACTER
			c: EL_CHARACTER_32_ROUTINES; unencoded: like unencoded_indexable
		do
			l_area := area
			if has_mixed_encoding then
				unencoded := unencoded_indexable
				from i := count - 1 until i < 0 loop
					c_i := l_area [i]
					-- `Unencoded_character' is space
					if c_i = Unencoded_character then
						if c.is_space (unencoded.item (i + 1)) then
							Result := Result + 1
						else
							i := 0 -- break out of loop
						end
					elseif c_i.is_space then
						Result := Result + 1
					else
						i := 0 -- break out of loop
					end
					i := i - 1
				end
			else
				from i := count - 1 until i < 0 loop
					-- `Unencoded_character' is space
					if l_area.item (i).is_space then
						Result := Result + 1
					else
						i := 0 -- break out of loop
					end
					i := i - 1
				end
			end
		ensure then
			substring_agrees: across substring (count - Result + 1, count) as uc all character_properties.is_space (uc.item) end
		end

	utf_8_byte_count: INTEGER
		local
			i, l_count: INTEGER; l_area: like area; unencoded_found: BOOLEAN
		do
			l_count := count; l_area := area
			from i := 0 until i = l_count loop
				if l_area [i] = Unencoded_character then
					unencoded_found := True
				else
					Result := Result + 1
				end
				i := i + 1
			end
			if unencoded_found then
				Result := Result + unencoded_utf_8_byte_count
			end
		end

feature {NONE} -- Implementation

	substring_index_list (delimiter: READABLE_STRING_GENERAL): LIST [INTEGER]
		deferred
		end

feature -- Constants

	Substitution_marker: EL_ZSTRING
		once
			Result := "%S"
		end

end