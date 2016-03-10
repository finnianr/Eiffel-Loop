note
	description: "Summary description for {TEST_UC_UTF8_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "5"

class
	UC_UTF8_STRING_TESTS

inherit
	STRING_TESTS [UC_UTF8_STRING]

create
	make

feature {NONE} -- Implementation

	index_of (l_uc: CHARACTER_32; s: UC_UTF8_STRING): INTEGER
		local
			uc: UC_CHARACTER
		do
			create uc.make_from_code (l_uc.code)
			Result := s.index_of_unicode (uc, 1)
		end

	create_string (unicode: STRING_32): UC_UTF8_STRING
		do
			create Result.make_from_string_general (unicode)
		end

	create_unicode (s: UC_UTF8_STRING): STRING_32
		do
			Result := s.as_string_32
		end

	storage_bytes (s: UC_UTF8_STRING): INTEGER
		local
			l_s: STRING
		do
			l_s := s
			Result := Eiffel.physical_size (s) + Eiffel.physical_size (l_s.area)
		end

end
