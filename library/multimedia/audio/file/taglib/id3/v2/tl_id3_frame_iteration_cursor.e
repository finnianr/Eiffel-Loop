note
	description: "Taglib ID3 frame iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 21:22:24 GMT (Monday 11th November 2019)"
	revision: "3"

class
	TL_ID3_FRAME_ITERATION_CURSOR

inherit
	EL_CPP_STD_ITERATION_CURSOR [TL_ID3_TAG_FRAME]

	TL_ID3_FRAME_LIST_ITERATOR_CPP_API

	TL_SHARED_FRAME_ID_BYTES

create
	make

feature -- Access

	item: TL_ID3_TAG_FRAME
		local
			frame: POINTER
		do
			frame := cpp_item (self_ptr)
			if cpp_is_attached_picture_type (frame) then
				create {TL_PICTURE_ID3_FRAME} Result.make (frame)
			elseif cpp_is_comments_type (frame) then
				create {TL_COMMENTS_ID3_FRAME} Result.make (frame)
			elseif cpp_is_text_identification_type (frame) then
				create {TL_TEXT_IDENTIFICATION_ID3_FRAME} Result.make (frame)
			else
				create Result.make (frame)
			end
		end

end
