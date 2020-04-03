note
	description: "Album picture underbit id3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-14 13:49:08 GMT (Monday 14th October 2019)"
	revision: "6"

class
	UNDERBIT_ID3_ALBUM_PICTURE_FRAME

inherit
	ID3_ALBUM_PICTURE_FRAME

	UNDERBIT_ID3_FRAME
		rename
			make as make_frame,
			binary_data as picture_data,
			integer as picture_type,
			latin_1_string as mime_type,
			set_binary_data as set_picture_data,
			set_integer as set_picture_type,
			set_latin_1_string as set_mime_type
		export
			{NONE} all
			{ANY} is_attached
		end

create
	make, make_frame

end
