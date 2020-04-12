note
	description: "Searchable aspects of [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-10 10:07:52 GMT (Friday 10th April 2020)"
	revision: "4"

deferred class
	EL_SEARCHABLE_ZSTRING

inherit
	EL_ZSTRING_IMPLEMENTATION

feature -- Access

	index_of (uc: CHARACTER_32; start_index: INTEGER): INTEGER
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			if c = Unencoded_character then
				Result := unencoded_index_of (uc.natural_32_code, start_index)
			else
				Result := internal_index_of (c, start_index)
			end
		ensure then
			valid_result: Result = 0 or (start_index <= Result and Result <= count)
			zero_if_absent: (Result = 0) = not substring (start_index, count).has (uc)
			found_if_present: substring (start_index, count).has (uc) implies item (Result) = uc
			none_before: substring (start_index, count).has (uc) implies
				not substring (start_index, Result - 1).has (uc)
		end

	index_of_z_code (a_z_code: NATURAL; start_index: INTEGER): INTEGER
		do
			if a_z_code <= 0xFF then
				Result := internal_index_of (a_z_code.to_character_8, start_index)
			else
				Result := unencoded_index_of (z_code_to_unicode (a_z_code), start_index)
			end
		ensure then
			valid_result: Result = 0 or (start_index <= Result and Result <= count)
			zero_if_absent: (Result = 0) = not substring (start_index, count).has_z_code (a_z_code)
			found_if_present: substring (start_index, count).has_z_code (a_z_code) implies z_code (Result) = a_z_code
			none_before: substring (start_index, count).has_z_code (a_z_code) implies
				not substring (start_index, Result - 1).has_z_code (a_z_code)
		end

	last_index_of (uc: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
			-- Position of last occurrence of `c',
			-- 0 if none.
		local
			c: CHARACTER
		do
			c := encoded_character (uc)
			if c = Unencoded_character then
				Result := unencoded_last_index_of (uc.natural_32_code, start_index_from_end)
			else
				Result := internal_last_index_of (c, start_index_from_end)
			end
		end

	substring_index (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		do
			inspect respective_encoding (other)
				when Both_have_mixed_encoding, Only_current, Neither then
					-- Make calls to `code' more efficient by caching calls to `unencoded_code' in expanded string
					Result := String_searcher.substring_index (current_readable, other.as_expanded (1), start_index, count)
				when Only_other then
					Result := 0
			else
			end
		end

	substring_index_general (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			Result := substring_index (adapted_argument (other, 1), start_index)
		end

	substring_index_in_bounds (other: EL_READABLE_ZSTRING; start_pos, end_pos: INTEGER): INTEGER
		do
			inspect respective_encoding (other)
				when Both_have_mixed_encoding, Only_current, Neither then
					-- Make calls to `code' more efficient by caching calls to `unencoded_code' in expanded string
					Result := String_searcher.substring_index (current_readable, other.as_expanded (1), start_pos, end_pos)
				when Only_other then
					Result := 0
			else
			end
		end

	substring_index_in_bounds_general (other: READABLE_STRING_GENERAL; start_pos, end_pos: INTEGER): INTEGER
		do
			Result := substring_index_in_bounds (adapted_argument (other, 1), start_pos, end_pos)
		end

	substring_right_index (other: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		-- index to right of first occurrence of `other' if valid index or else 0
		do
			Result := substring_index (other, start_index)
			if Result > 0 then
				Result := Result + other.count
			end
		end

	substring_right_index_general (other: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			Result := substring_index_general (other, start_index)
			if Result > 0 then
				Result := Result + other.count
			end
		end

	word_index (word: EL_READABLE_ZSTRING; start_index: INTEGER): INTEGER
		local
			has_left_boundary, has_right_boundary, found: BOOLEAN
			index: INTEGER
		do
			from index := start_index; Result := 1 until Result = 0 or else found or else index + word.count - 1 > count loop
				Result := substring_index (word, index)
				if Result > 0 then
					has_left_boundary := Result = 1 or else not is_alpha_numeric_item (Result - 1)
					has_right_boundary := Result + word.count - 1 = count or else not is_alpha_numeric_item (Result + word.count)
					if has_left_boundary and has_right_boundary then
						found := True
					else
						index := Result + 1
					end
				end
			end
		end

	word_index_general (word: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			Result := word_index (adapted_argument (word, 1), start_index)
		end

feature {NONE} -- Implementation

	is_alpha_numeric_item (i: INTEGER): BOOLEAN
		deferred
		end

feature {NONE} -- Constants

	String_searcher: EL_ZSTRING_SEARCHER
		once
			create Result.make
		end

end
