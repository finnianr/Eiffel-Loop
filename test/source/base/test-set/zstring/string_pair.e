note
	description: "[
		Object for testing [$source ZSTRING] against [$source STRING_32] in [$source ZSTRING_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-14 18:40:59 GMT (Tuesday 14th February 2023)"
	revision: "8"

class
	STRING_PAIR

inherit
	ANY
	 	redefine
	 		default_create
	 	end
create
	default_create, make, make_filled

convert
	make ({STRING_32})

feature {NONE} -- Initialization

	default_create
		do
			make_filled (' ', 0)
		end

	make (str: STRING_32)
		do
			set (str)
			s_32_substring := s_32; zs_substring := zs
		end

	make_filled (c: CHARACTER_32; n: INTEGER)
		do
			create s_32.make_filled (c, n)
			create zs.make_filled (c, n)
			s_32_substring := s_32; zs_substring := zs
		end

feature -- Strings

	s_32: STRING_32

	s_32_substring: STRING_32

	zs: ZSTRING

	zs_substring: ZSTRING

feature -- Access

	latin_1: detachable STRING_8
		do
			if s_32.is_valid_as_string_8 then
				Result := s_32.to_string_8
			end
		end

	new_intervals (separator: CHARACTER_32): EL_SPLIT_INTERVALS
		do
			create Result.make (s_32, separator)
		end

	hash_code: INTEGER
		do
			Result := (s_32.hash_code + s_32_substring.hash_code).abs
		end

feature -- Test comparisons

	ends_with: BOOLEAN
		local
			b1, b2, b3: BOOLEAN
		do
			b1 := s_32.ends_with (s_32_substring)
			b2 := zs.ends_with (s_32_substring)
			b3 := zs.ends_with (zs_substring)
			Result := b1 = b2
			Result := Result and b1 = b3
			if Result and then s_32.is_valid_as_string_8 then
				b3 := zs.ends_with_general (s_32_substring.to_string_8)
				Result := b1 = b3
			end
		end

	same_substring (start_index, end_index: INTEGER): BOOLEAN
		local
			substring: ZSTRING
		do
			substring := zs.substring (start_index, end_index)
			Result := substring.to_string_32 ~ s_32.substring (start_index, end_index)
		end

	same_characters (index: INTEGER): BOOLEAN
		local
			b1, b2, b3: BOOLEAN
		do
			b1 := s_32.same_characters (s_32_substring, 1, s_32_substring.count, index)
			b2 := zs.same_characters (s_32_substring, 1, s_32_substring.count, index)
			b3 := zs.same_characters (zs_substring, 1, zs_substring.count, index)
			Result := b1 = b2
			Result := Result and b1 = b3
			if Result and then s_32.is_valid_as_string_8 then
				b3 := zs.same_characters (s_32_substring.to_string_8, 1, s_32_substring.count, index)
				Result := b1 = b3
			end
		end

	starts_with: BOOLEAN
		local
			b1, b2, b3: BOOLEAN
		do
			b1 := s_32.starts_with (s_32_substring)
			b2 := zs.starts_with (s_32_substring)
			b3 := zs.starts_with (zs_substring)
			Result := b1 = b2
			Result := Result and b1 = b3
			if Result and then s_32.is_valid_as_string_8 then
				b3 := zs.starts_with_general (s_32_substring.to_string_8)
				Result := b1 = b3
			end
		end

	substring_index (from_index: INTEGER): BOOLEAN
		local
			index_1, index_2: INTEGER
		do
			index_1 := s_32.substring_index (s_32_substring, from_index)
			index_2 := zs.substring_index (zs_substring, from_index)
			Result := index_1 = index_2
		end

feature -- Status query

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := s_32.valid_index (i)
		end

	is_same: BOOLEAN
		do
			Result := zs.same_string (s_32)
		end

feature -- Element change

	set (str_32: STRING_32)
		do
			s_32 := str_32; zs := str_32
		end

feature -- Basic operations

	append_character (c: CHARACTER_32)
		do
			s_32.append_character (c)
			zs.append_character (c)
		end

	set_z_from_uc
		do
			zs := s_32
		end

	set_substrings (start_index, end_index: INTEGER)
		do
			s_32_substring := s_32.substring (start_index, end_index)
			zs_substring := zs.substring (start_index, end_index)
		end

	wipe_out
		do
			s_32.wipe_out; zs.wipe_out
		end

end