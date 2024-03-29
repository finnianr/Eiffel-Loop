note
	description: "ID3 V2 header"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	TL_ID3_V2_HEADER

inherit
	TL_ID3_HEADER
		redefine
			complete_tag_size, major_version, revision_number, tag_size
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

feature -- Measurement

	complete_tag_size: INTEGER
		do
			Result := cpp_complete_tag_size (self_ptr)
		end

	tag_size: INTEGER
		do
			Result := cpp_tag_size (self_ptr)
		end
end