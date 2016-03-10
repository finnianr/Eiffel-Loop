note
	description: "Summary description for {EL_UNDERBIT_ID3_ALBUM_PICTURE_FRAME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "4"

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
