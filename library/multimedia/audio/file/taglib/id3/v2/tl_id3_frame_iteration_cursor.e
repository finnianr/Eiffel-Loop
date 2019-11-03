note
	description: "Taglib ID3 frame iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 14:15:34 GMT (Thursday 31st October 2019)"
	revision: "2"

class
	TL_ID3_FRAME_ITERATION_CURSOR

inherit
	EL_CPP_STD_ITERATION_CURSOR [TL_ID3_TAG_FRAME]

	TL_ID3_FRAME_LIST_ITERATOR_CPP_API

create
	make

feature -- Access

	item: TL_ID3_TAG_FRAME
		local
			id: TL_BYTE_VECTOR
			frame: POINTER
		do
			frame := cpp_item (self_ptr)
			create id.make ({TL_ID3_TAG_FRAME_CPP_API}.cpp_frame_id (frame))
			if id.equals (once "APIC") then
				create {TL_PICTURE_ID3_FRAME} Result.make (frame)
			elseif id.equals (once "COMM") then
				create {TL_COMMENTS_ID3_FRAME} Result.make (frame)
			elseif id.starts_with (once "T") or else id.equals (once "WFED") then
				create {TL_TEXT_IDENTIFICATION_ID3_FRAME} Result.make (frame)
			else
				create Result.make (frame)
			end
		end

end
