note
	description: "Album picture id3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	ID3_ALBUM_PICTURE_FRAME

inherit
	ID3_FRAME
		rename
			binary_data as picture_data,
			integer as picture_type,
			latin_1_string as mime_type,
			set_binary_data as set_picture_data,
			set_integer as set_picture_type,
			set_latin_1_string as set_mime_type
		end

feature {NONE} -- Initialization

	make (a_picture: ID3_ALBUM_PICTURE)
			--
		do
			make_new (Tag.Album_picture)
			set_mime_type (a_picture.mime_type)
			set_picture_data (a_picture.data)
			set_description (a_picture.description)
		end

feature -- Access

	picture: ID3_ALBUM_PICTURE
		do
			create Result.make (picture_data, description, mime_type)
		end

end