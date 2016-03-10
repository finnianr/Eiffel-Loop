note
	description: "Summary description for {TEST_STRING_32}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "5"

class
	STRING_32_TESTS

inherit
	STRING_TESTS [STRING_32]

create
	make

feature {NONE} -- Implementation

	index_of (uc: CHARACTER_32; s: STRING_32): INTEGER
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
			Result := Eiffel.physical_size (s) + Eiffel.physical_size (s.area)
		end

end
