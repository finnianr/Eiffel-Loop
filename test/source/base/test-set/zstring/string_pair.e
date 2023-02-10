note
	description: "[
		Object for testing [$source ZSTRING] against [$source STRING_32] in [$source ZSTRING_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-10 11:52:51 GMT (Friday 10th February 2023)"
	revision: "4"

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
			create s_32.make_empty; create z_32.make_empty
		end

	make (str: STRING_32)
		do
			set (str)
		end

	make_filled (c: CHARACTER_32; n: INTEGER)
		do
			create s_32.make_filled (c, n)
			create z_32.make_filled (c, n)
		end

feature -- Access

	s_32: STRING_32

	latin_1: detachable STRING_8
		do
			if s_32.is_valid_as_string_8 then
				Result := s_32.to_string_8
			end
		end

	z_32: ZSTRING

feature -- Status query

	is_same: BOOLEAN
		do
			Result := z_32.same_string (s_32)
		end

	same_substring (start_index, end_index: INTEGER): BOOLEAN
		local
			substring: ZSTRING
		do
			substring := z_32.substring (start_index, end_index)
			Result := substring.to_string_32 ~ s_32.substring (start_index, end_index)
		end

feature -- Basic operations

	append_character (c: CHARACTER_32)
		do
			s_32.append_character (c)
			z_32.append_character (c)
		end

	set (str_32: STRING_32)
		do
			s_32 := str_32
			z_32 := str_32
		end

	set_z_from_uc
		do
			z_32 := s_32
		end

	wipe_out
		do
			s_32.wipe_out; z_32.wipe_out
		end

end