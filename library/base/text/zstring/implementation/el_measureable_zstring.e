note
	description: "Measureable aspects of [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-05 14:54:04 GMT (Sunday 5th April 2020)"
	revision: "1"

deferred class
	EL_MEASUREABLE_ZSTRING

inherit
	EL_ZSTRING_UNICODE_IMPLEMENTATION

feature -- Measurement

	Lower: INTEGER = 1

	leading_occurrences (uc: CHARACTER_32): INTEGER
			-- Returns count of continous occurrences of `uc' or white space starting from the begining
		local
			i, l_count: INTEGER; l_area: like area; c, c_i: CHARACTER; uc_code: NATURAL
		do
			c := encoded_character (uc); uc_code := uc.natural_32_code
			l_area := area; l_count := count
			if c = Unencoded_character then
				if has_mixed_encoding then
					from i := 0 until i = l_count loop
						c_i := l_area [i]
						if c_i = Unencoded_character and then unencoded_code (i + 1) = uc_code then
							Result := Result + 1
						else
							i := l_count - 1 -- break out of loop
						end
						i := i + 1
					end
				end
			else
				from i := 0 until i = l_count loop
					c_i := l_area [i]
					-- `Unencoded_character' is space
					if c_i = c then
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
			l_prop: like character_properties
		do
			l_area := area; l_count := count; l_prop := character_properties
			from i := 0 until i = l_count loop
				c_i := l_area [i]
				-- `Unencoded_character' is space
				if c_i = Unencoded_character then
					if l_prop.is_space (unencoded_item (i + 1)) then
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
			l_unencoded: like unencoded_interval_index; uc_code: NATURAL
		do
			c := encoded_character (uc); uc_code := uc.natural_32_code
			l_area := area; l_unencoded := unencoded_interval_index
			if c = Unencoded_character then
				if has_mixed_encoding then
					from i := count - 1 until i < 0 loop
						c_i := l_area [i]
						if c_i = Unencoded_character and then unencoded_code (i + 1) = uc_code then
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
			l_unencoded: like unencoded_interval_index; l_prop: like character_properties
		do
			l_area := area; l_unencoded := unencoded_interval_index; l_prop := character_properties
			from i := count - 1 until i < 0 loop
				c_i := l_area [i]
				-- `Unencoded_character' is space
				if c_i = Unencoded_character then
					if l_prop.is_space (l_unencoded.code (i + 1).to_character_32) then
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

	substring_index_list (delimiter: EL_READABLE_ZSTRING): LIST [INTEGER]
		deferred
		end

feature -- Constants

	Substitution_marker: EL_ZSTRING
		once
			Result := "%S"
		end

end
