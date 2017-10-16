note
	description: "Summary description for {ID3_EDIT_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	ID3_EDIT_CONSTANTS

feature {NONE} -- Constants

	ID3_frame_c0: ZSTRING
			-- Rhythmbox standard comment description
		once
			Result := "c0"
		end

	ID3_frame_comment: ZSTRING
			-- Rhythmbox non-standard comment description
		once
			Result := "Comment"
		end

	ID3_frame_performers: ZSTRING
		once
			Result := "Performers"
		end

	Comment_fields: ARRAY [ZSTRING]
		once
			Result := << Field_artists, Field_singers >>
			Result.compare_objects
		end

	Field_artists: ZSTRING
		once
			Result := "Artists"
		end

	Field_singers: ZSTRING
		once
			Result := "Singers"
		end

end