note
	description: "Summary description for {EL_UNDERBIT_ID3_ALBUM_PICTURE_FRAME}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_ALBUM_PICTURE_UNDERBIT_ID3_FRAME

inherit
	EL_ALBUM_PICTURE_ID3_FRAME
		undefine
			make_from_pointer
		end

	EL_UNDERBIT_ID3_FRAME
		export
			{NONE} all
			{ANY} is_attached
		undefine
			string, set_description, description
		end

create
	make, make_from_pointer

feature {NONE} -- Implementation

	Mime_type_index: INTEGER = 2

	Description_index: INTEGER = 4

	Image_index: INTEGER = 5

end
