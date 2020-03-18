note
	description: "Taglib ID3 frame iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-18 16:52:47 GMT (Wednesday 18th March 2020)"
	revision: "7"

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
				create {TL_CHAPTER_ID3_FRAME} Result.make_from_pointer (frame)

			elseif {TL_COMMENTS_ID3_FRAME}.cpp_conforms (frame) then
				create {TL_COMMENTS_ID3_FRAME} Result.make_from_pointer (frame)

			elseif {TL_PICTURE_ID3_FRAME}.cpp_conforms (frame) then
				create {TL_PICTURE_ID3_FRAME} Result.make_from_pointer (frame)

			elseif {TL_TEXT_IDENTIFICATION_ID3_FRAME}.cpp_conforms (frame) then
				create {TL_TEXT_IDENTIFICATION_ID3_FRAME} Result.make_from_pointer (frame)

			elseif {TL_UNIQUE_FILE_IDENTIFIER_FRAME}.cpp_conforms (frame) then
				create {TL_UNIQUE_FILE_IDENTIFIER_FRAME} Result.make_from_pointer (frame)
				
			else
				create Result.make_from_pointer (frame)
			end
		end

end
