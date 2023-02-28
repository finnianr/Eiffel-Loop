note
	description: "[
		Object for testing [$source ZSTRING] against [$source STRING_32] in [$source ZSTRING_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-28 11:33:31 GMT (Tuesday 28th February 2023)"
	revision: "18"

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

feature -- STRING_32

	s_32: STRING_32

	s_32_new: STRING_32

	s_32_old: STRING_32

	s_32_substring: READABLE_STRING_32

	s_8: detachable STRING_8

feature -- STRING_8

	s_8_new: detachable STRING_8

	s_8_old: detachable STRING_8

	s_8_substring: detachable READABLE_STRING_8

feature -- ZSTRING

	zs: ZSTRING

	zs_new: ZSTRING

	zs_old: ZSTRING

	zs_substring: ZSTRING

feature -- Access

	hash_code: INTEGER
		do
			across << s_32, s_32_substring, s_32_old, s_32_new >> as list loop
				if attached list.item as str_32 then
					Result := Result + str_32.hash_code
				end
			end
			Result := Result.abs
		end

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

feature -- Test comparisons

	append_string_general: BOOLEAN
		do
			if attached s_8_substring as str_8 then
				zs.append_string_general (str_8)
			else
				zs.append_string_general (s_32_substring)
			end
			if zs.count = s_32.count then
				Result := zs.to_string_32 ~ s_32
			else
				Result := s_32.starts_with (zs.to_string_32)
			end
		end

	append_substring_general (start_index, end_index: INTEGER): BOOLEAN
		do
			if attached s_8 as s then
				zs.append_substring_general (s, start_index, end_index)
			else
				zs.append_substring_general (s_32, start_index, end_index)
			end
			if zs.count = s_32.count then
				Result := zs.to_string_32 ~ s_32
			else
				Result := s_32.starts_with (zs.to_string_32)
			end
		end

	ends_with: BOOLEAN
		local
			b1, b2, b3: BOOLEAN
		do
			b1 := s_32.ends_with (s_32_substring)
			b2 := zs.ends_with (s_32_substring)
			b3 := zs.ends_with (zs_substring)
			Result := b1 = b2
			Result := Result and b1 = b3
			if Result and then attached s_8_substring as s then
				b3 := zs.ends_with_general (s)
				Result := b1 = b3
			end
		end

	replace_substring_all: BOOLEAN
		do
			s_32.replace_substring_all (s_32_old, s_32_new)
			if attached s_8_old as l_old and attached s_8_new as l_new then
				zs.replace_substring_all (l_old, l_new)

			elseif attached s_8_new as l_new then
				zs.replace_substring_all (zs_old, l_new)

			elseif attached s_8_old as l_old then
				zs.replace_substring_all (l_old, zs_new)
			else
				zs.replace_substring_all (zs_old, zs_new)
			end
			Result := zs.same_string (s_32)
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
			if Result and then attached s_8_substring as s then
				b3 := zs.same_characters_general (s, 1, s.count, index)
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

	starts_with: BOOLEAN
		local
			b1, b2, b3: BOOLEAN
		do
			b1 := s_32.starts_with (s_32_substring)
			b2 := zs.starts_with (s_32_substring)
			b3 := zs.starts_with (zs_substring)
			Result := b1 = b2
			Result := Result and b1 = b3
			if Result and then attached s_8_substring as str_8 then
				b3 := zs.starts_with_general (str_8)
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
			if Result then
				index_2 := zs.substring_index (s_32_substring, from_index)
				Result := index_1 = index_2
			end
			if Result and then attached s_8_substring as str_8 then
				index_2 := zs.substring_index (s_8_substring, from_index)
				Result := index_1 = index_2
			end
		end

	to_general: BOOLEAN
		do
			if attached s_8 as str_8 then
				create zs.make_from_general (str_8)
				if attached {STRING_8} zs.to_general as as_str_8 then
					Result := as_str_8 ~ str_8
				end
			elseif attached {STRING_32} zs.to_general as str_32 then
				Result := str_32 ~ s_32
			end
		end

feature -- Status query

	is_same: BOOLEAN
		do
			Result := zs.same_string (s_32)
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := s_32.valid_index (i)
		end

	is_same_size: BOOLEAN
		do
			Result := zs.count = s_32.count
		end

feature -- Element change

	set (str_32: STRING_32)
		do
			s_32 := str_32; zs := str_32
			if s_32.is_valid_as_string_8 then
				s_8 := s_32.to_string_8
			else
				s_8 := Void
			end
		end

	set_old_new (a_old, a_new: STRING_32)
		do
			s_32_old := a_old; s_32_new := a_new
			zs_old := a_old; zs_new := a_new

			if a_old.is_valid_as_string_8 then
				s_8_old := a_old
			else
				s_8_old := Void
			end
			if a_new.is_valid_as_string_8 then
				s_8_new := a_new
			else
				s_8_new := Void
			end
		end

	set_substrings (start_index, end_index: INTEGER)
		do
			s_32_substring := s_32.substring (start_index, end_index)
			create zs_substring.make_from_string (s_32_substring)

			if s_32_substring.is_valid_as_string_8 then
				s_8_substring := s_32_substring.to_string_8
			else
				s_8_substring := Void
			end
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

	wipe_out
		do
			s_32.wipe_out; zs.wipe_out
		end

end