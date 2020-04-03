note
	description: "Underbit id3 genre frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-14 13:48:47 GMT (Monday 14th October 2019)"
	revision: "1"

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
