note
	description: "Tl id3 v2 header"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-26 17:18:00 GMT (Saturday   26th   October   2019)"
	revision: "1"

class
	TL_ID3_V2_HEADER

inherit
	EL_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_ID3_V2_HEADER_CPP_API

create
	make

feature -- Access

	major_version: INTEGER
		do
			Result := cpp_major_version (self_ptr)
		end

	revision_number: INTEGER
		do
			Result := cpp_revision_number (self_ptr)
		end

	tag_size: INTEGER
		do
			Result := cpp_tag_size (self_ptr)
		end
end
