note
	description: "Summary description for {TEST_STRING_32}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-23 16:59:34 GMT (Tuesday 23rd July 2013)"
	revision: "3"

class
	STRING_32_TESTS

inherit
	STRING_TESTS [STRING_32]

create
	make

feature {NONE} -- Implementation

	index_of_unicode (uc: CHARACTER_32; s: STRING_32): INTEGER
		do
			Result := s.index_of (uc, 1)
		end

	create_string (unicode: STRING_32): STRING_32
		do
			create Result.make_from_string_general (unicode)
		end

	create_unicode (s: STRING_32): STRING_32
		do
			Result := s.as_string_32
		end

	storage_bytes (s: STRING_32): INTEGER
		do
			Result := Typing.physical_size (s) + Typing.physical_size (s.area)
		end

end
