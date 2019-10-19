note
	description: "Summary description for {UNDERBIT_ID3_GENRE_FRAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
