note
	description: "Summary description for {ID3_EDIT_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 9:25:53 GMT (Wednesday 16th December 2015)"
	revision: "6"

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
