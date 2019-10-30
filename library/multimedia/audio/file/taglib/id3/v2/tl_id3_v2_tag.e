note
	description: "ID3 ver. 2.x tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-30 17:24:56 GMT (Wednesday   30th   October   2019)"
	revision: "4"

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

feature {NONE} -- Implementation

	new_frame_list: EL_CPP_STD_LIST [TL_ID3_FRAME_ITERATION_CURSOR, TL_ID3_TAG_FRAME]
		do
			create Result.make (agent cpp_frame_list_begin (self_ptr), agent cpp_frame_list_end (self_ptr))
		end

end
