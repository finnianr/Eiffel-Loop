note
	description: "Taglib ID3 frame iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-12 14:55:01 GMT (Tuesday 12th November 2019)"
	revision: "5"

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
			frame: POINTER
		do
			frame := cpp_item (self_ptr)
			if {TL_CHAPTER_ID3_FRAME}.cpp_conforms (frame) then
				create {TL_CHAPTER_ID3_FRAME} Result.make (frame)

			elseif {TL_COMMENTS_ID3_FRAME}.cpp_conforms (frame) then
				create {TL_COMMENTS_ID3_FRAME} Result.make (frame)

			elseif {TL_PICTURE_ID3_FRAME}.cpp_conforms (frame) then
				create {TL_PICTURE_ID3_FRAME} Result.make (frame)

			elseif {TL_TEXT_IDENTIFICATION_ID3_FRAME}.cpp_conforms (frame) then
				create {TL_TEXT_IDENTIFICATION_ID3_FRAME} Result.make (frame)
			else
				create Result.make (frame)
			end
		end

end
