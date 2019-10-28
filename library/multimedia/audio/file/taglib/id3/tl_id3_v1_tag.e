note
	description: "TagLib::ID3v2::Tag <id3v2tag.h>"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-27 16:22:58 GMT (Sunday   27th   October   2019)"
	revision: "2"

class
	TL_ID3_V1_TAG

inherit
	TL_ID3_TAG

	TL_ID3_V1_TAG_CPP_API

create
	make

feature -- Access

	title: TL_STRING
		do
			create Result.make
		end
end
