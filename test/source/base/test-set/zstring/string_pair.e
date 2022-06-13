note
	description: "[
		Object for testing [$source ZSTRING] against [$source STRING_32] in [$source ZSTRING_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-13 12:48:49 GMT (Monday 13th June 2022)"
	revision: "1"

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
			create uc.make_empty; create z.make_empty
		end

	make (str: STRING_32)
		do
			set (str)
		end

	make_filled (c: CHARACTER_32; n: INTEGER)
		do
			create uc.make_filled (c, n)
			create z.make_filled (c, n)
		end

feature -- Access

	uc: STRING_32

	latin_1: detachable STRING_8
		do
			if uc.is_valid_as_string_8 then
				Result := uc.to_string_8
			end
		end

	z: ZSTRING

feature -- Status query

	is_same: BOOLEAN
		do
			Result := z.same_string (uc)
		end

feature -- Basic operations

	append_character (c: CHARACTER_32)
		do
			uc.append_character (c)
			z.append_character (c)
		end

	set (str_32: STRING_32)
		do
			uc := str_32
			z := str_32
		end

	set_z_from_uc
		do
			z := uc
		end

	wipe_out
		do
			uc.wipe_out; z.wipe_out
		end


end