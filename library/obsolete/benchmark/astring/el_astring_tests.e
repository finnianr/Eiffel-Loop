note
	description: "Summary description for {TEST_EL_STRING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:19:03 GMT (Wednesday 16th December 2015)"
	revision: "7"

class
	EL_ASTRING_TESTS

inherit
	STRING_TESTS [EL_ASTRING]
		redefine
			create_name
		end

	EL_SHARED_CODEC

create
	make

feature {NONE} -- Implementation

	index_of (uc: CHARACTER_32; s: EL_ASTRING): INTEGER
		do
			Result := s.index_of (uc, 1)
		end

	create_name: EL_ASTRING
		do
			Result := Precursor + " codec: " + system_codec.name
		end

	create_string (unicode: STRING_32): EL_ASTRING
		do
			create Result.make_from_unicode (unicode)
		end

	create_unicode (s: EL_ASTRING): STRING_32
		do
			Result := s.to_unicode
		end

	storage_bytes (s: EL_ASTRING): INTEGER
		do
			Result := Eiffel.physical_size (s) + Eiffel.physical_size (s.area)
			if s.has_foreign_characters then
				Result := Result + Eiffel.physical_size (s.foreign_characters)
			end
		end

end