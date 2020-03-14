note
	description: "ID3 V2 header"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-13 13:56:00 GMT (Friday 13th March 2020)"
	revision: "3"

class
	TL_ID3_V2_HEADER

inherit
	TL_ID3_HEADER
		redefine
			major_version, revision_number, tag_size
		end

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
