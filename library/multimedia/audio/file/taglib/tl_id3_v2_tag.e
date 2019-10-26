note
	description: "TagLib::ID3v2::Tag <id3v2tag.h>"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 10:40:07 GMT (Saturday   26th   October   2019)"
	revision: "1"

class
	TL_ID3_V2_TAG

inherit
	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_ID3_V2_TAG_CPP_API

create
	make

feature -- Access

	header: TL_ID3_V2_HEADER
		do
			create Result.make (cpp_header (self_ptr))
		end

end
