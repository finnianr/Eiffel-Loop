note
	description: "Summary description for {EL_LIBID3_ALBUM_PICTURE_FRAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_ALBUM_PICTURE_LIBID3_FRAME

inherit
	EL_ALBUM_PICTURE_ID3_FRAME
		undefine
			make_from_pointer
		end

	EL_LIBID3_FRAME
		undefine
			set_description, description
		end

	EL_LIBID3_CONSTANTS
		undefine
			out
		end

create
	make, make_from_pointer

feature {NONE} -- Implementation

	Mime_type_index: INTEGER = 3

	Description_index: INTEGER = 5

	Image_index: INTEGER = 6


end
