note
	description: "Summary description for {EL_UNDERBIT_ID3_ALBUM_PICTURE_FRAME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

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