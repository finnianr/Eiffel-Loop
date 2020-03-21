note
	description: "A default ID3 tag with version = 0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 12:53:41 GMT (Saturday 21st March 2020)"
	revision: "8"

class
	TL_ID3_V0_TAG

inherit
	TL_ID3_TAG

feature -- Fields

	album, artist, comment, title: ZSTRING
		do
			create Result.make_empty
		end

	version, duration, type: INTEGER
		do
		end

feature -- Element change

	set_picture (a_picture: TL_ID3_PICTURE)
		do
		end

	set_album, set_album_artist, set_artist, set_composer, set_title (a_title: READABLE_STRING_GENERAL)
		do
		end

end
