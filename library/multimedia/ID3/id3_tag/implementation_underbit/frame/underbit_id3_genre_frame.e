note
	description: "Underbit id3 genre frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-18 7:57:55 GMT (Friday 18th August 2023)"
	revision: "3"

class
	UNDERBIT_ID3_GENRE_FRAME

inherit
	UNDERBIT_ID3_FRAME
		redefine
			string
		end

	UNDERBIT_ID3_STRING_ROUTINES
	
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

	genre_string (index: INTEGER): ZSTRING
			--
		local
			ucs4_ptr: POINTER
		do
			ucs4_ptr := c_id3_genre_index (index)
			if is_attached (ucs4_ptr) then
				Result := from_ucs_4 (ucs4_ptr)
			else
				create Result.make_empty
			end
		end

end