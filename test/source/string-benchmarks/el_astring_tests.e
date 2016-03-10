note
	description: "Summary description for {TEST_EL_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "5"

class
	EL_ASTRING_TESTS

inherit
	STRING_TESTS [ASTRING]
		redefine
			create_name
		end

	EL_SHARED_CODEC

create
	make

feature {NONE} -- Implementation

	index_of (uc: CHARACTER_32; s: ASTRING): INTEGER
		do
			Result := s.index_of (uc, 1)
		end

	create_name: ASTRING
		do
			Result := Precursor + " codec: " + system_codec.name
		end

	create_string (unicode: STRING_32): ASTRING
		do
			create Result.make_from_unicode (unicode)
		end

	create_unicode (s: ASTRING): STRING_32
		do
			Result := s.to_unicode
		end

	storage_bytes (s: ASTRING): INTEGER
		do
			Result := Eiffel.physical_size (s) + Eiffel.physical_size (s.area)
			if s.has_foreign_characters then
				Result := Result + Eiffel.physical_size (s.foreign_characters)
			end
		end

end
