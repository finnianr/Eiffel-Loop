note
	description: "Summary description for {EL_LIBID3_ALBUM_PICTURE_FRAME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

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