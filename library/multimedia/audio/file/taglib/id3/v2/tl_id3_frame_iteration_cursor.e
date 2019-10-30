note
	description: "Tl id3 frame iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-30 18:07:55 GMT (Wednesday   30th   October   2019)"
	revision: "1"

class
	TL_ID3_FRAME_ITERATION_CURSOR

inherit
	EL_CPP_STD_ITERATION_CURSOR [TL_ID3_TAG_FRAME]

	TL_ID3_FRAME_LIST_ITERATOR_CPP_API

create
	make

feature -- Access

	item: TL_ID3_TAG_FRAME
		do
			create Result.make (cpp_item (self_ptr))
		end

end
