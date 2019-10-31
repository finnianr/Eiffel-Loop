note
	description: "ID3 ver. 2.x tag"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 15:27:25 GMT (Thursday   31st   October   2019)"
	revision: "5"

class
	TL_ID3_V2_TAG

inherit
	TL_ID3_TAG

	TL_ID3_V2_TAG_CPP_API

create
	make

feature -- Access

	frame_count: INTEGER
		do
			Result := cpp_frame_count (self_ptr)
		end

	frame_list: EL_ARRAYED_LIST [TL_ID3_TAG_FRAME]
		do
			create Result.make (frame_count)
			across iterable_frame_list as frame loop
				Result.extend (frame.item)
			end
		end

	header: TL_ID3_V2_HEADER
		do
			create Result.make (cpp_header (self_ptr))
		end

	iterable_frame_list: EL_CPP_STD_LIST [TL_ID3_FRAME_ITERATION_CURSOR, TL_ID3_TAG_FRAME]
		do
			create Result.make (agent cpp_frame_list_begin (self_ptr), agent cpp_frame_list_end (self_ptr))
		end

end
