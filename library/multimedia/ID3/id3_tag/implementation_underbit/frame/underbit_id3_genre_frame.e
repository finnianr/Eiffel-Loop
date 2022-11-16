note
	description: "Underbit id3 genre frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	UNDERBIT_ID3_GENRE_FRAME

inherit
	UNDERBIT_ID3_FRAME
		redefine
			string
		end

create
	make, make_new

feature -- Access

	string: ZSTRING
		do
			Result := Precursor
			if Result.is_integer then
				Result := genre_string (Result.to_integer)
			end
		end

feature {NONE} -- Implementation

	genre_string (index: INTEGER): STRING
			--
		local
			ucs4_ptr: POINTER; latin1: EL_C_STRING_8
		do
			ucs4_ptr := c_id3_genre_index (index)
			if is_attached (ucs4_ptr) then
				create latin1.make_owned (c_id3_ucs4_latin1duplicate (ucs4_ptr))
				Result := latin1.as_string_8
			else
				create Result.make_empty
			end
		end

end