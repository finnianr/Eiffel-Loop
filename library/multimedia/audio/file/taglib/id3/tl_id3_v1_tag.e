note
	description: "ID3 ver. 1.0 Tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 11:13:34 GMT (Monday 11th November 2019)"
	revision: "5"

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

	title: ZSTRING
		do
			cpp_get_title (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

end
