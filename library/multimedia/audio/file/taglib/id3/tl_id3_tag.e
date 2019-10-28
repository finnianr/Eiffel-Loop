note
	description: "TagLib::ID3v2::Tag <id3v2tag.h>"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-27 11:10:36 GMT (Sunday   27th   October   2019)"
	revision: "2"

deferred class
	TL_ID3_TAG

inherit
	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		end

feature -- Access

	title: TL_STRING
		deferred
		end

end
