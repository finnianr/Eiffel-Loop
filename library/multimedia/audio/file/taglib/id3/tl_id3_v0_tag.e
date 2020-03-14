note
	description: "A default ID3 tag with version = 0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 18:58:47 GMT (Saturday 14th March 2020)"
	revision: "5"

class
	TL_ID3_V0_TAG

inherit
	TL_ID3_TAG

feature -- Fields

	album, artist, comment, title: ZSTRING
		do
			create Result.make_empty
		end

	version, duration: INTEGER
		do
		end

feature -- Element change

	set_picture (a_picture: TL_ID3_PICTURE)
		do
		end
end
