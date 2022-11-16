note
	description: "Album picture libid3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

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
		end

	LIBID3_CONSTANTS

create
	make, make_from_pointer

end