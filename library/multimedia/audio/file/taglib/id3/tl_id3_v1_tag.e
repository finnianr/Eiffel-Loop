note
	description: "ID3 ver. 1.0 Tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 18:58:47 GMT (Saturday 14th March 2020)"
	revision: "6"

class
	TL_ID3_V1_TAG

inherit
	TL_ID3_TAG

	TL_ID3_V1_TAG_CPP_API

create
	make

feature -- Access

	album: ZSTRING
		do
			cpp_get_album (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	artist: ZSTRING
		do
			cpp_get_artist (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	comment: ZSTRING
		do
			cpp_get_comment (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	duration: INTEGER
		do
		end

	title: ZSTRING
		do
			cpp_get_title (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

feature -- Element change

	set_picture (a_picture: TL_ID3_PICTURE)
		do
		end

feature -- Constants

	version: INTEGER = 1
		-- ID3 version number

end
