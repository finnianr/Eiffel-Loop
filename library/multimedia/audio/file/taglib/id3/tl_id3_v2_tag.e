note
	description: "TagLib::ID3v2::Tag <id3v2tag.h>"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-28 12:10:19 GMT (Monday   28th   October   2019)"
	revision: "3"

class
	TL_ID3_V2_TAG

inherit
	TL_ID3_TAG

	TL_ID3_V2_TAG_CPP_API

create
	make

feature -- Access

	header: TL_ID3_V2_HEADER
		do
			create Result.make (cpp_header (self_ptr))
		end

end
