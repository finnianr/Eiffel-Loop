note
	description: "Album picture libid3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	LIBID3_ALBUM_PICTURE_FRAME

inherit
	ID3_ALBUM_PICTURE_FRAME

	LIBID3_FRAME
		rename
			binary_data as picture_data,
			integer as picture_type,
			latin_1_string as mime_type,
			set_binary_data as set_picture_data,
			set_integer as set_picture_type,
			set_latin_1_string as set_mime_type
		undefine
			set_description, description
		end

	LIBID3_CONSTANTS

create
	make, make_from_pointer

end
