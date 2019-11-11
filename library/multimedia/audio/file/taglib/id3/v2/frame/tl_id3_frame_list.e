note
	description: "Tl id3 frame list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 10:37:07 GMT (Monday 11th November 2019)"
	revision: "2"

class
	TL_ID3_FRAME_LIST

inherit
	EL_OWNED_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_ID3_FRAME_LIST_CPP_API

	TL_SHARED_ONCE_STRING

	ITERABLE [TL_ID3_TAG_FRAME]

create
	make


feature -- Status query

	is_empty: BOOLEAN
		do
			Result := cpp_is_empty (self_ptr)
		end

feature -- Access

	first_text: ZSTRING
		do
			cpp_get_first_text (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

feature {NONE} -- Implementation

	new_cursor: TL_ID3_FRAME_ITERATION_CURSOR
		do
			create Result.make (cpp_iterator_begin (self_ptr), cpp_iterator_end (self_ptr))
		end
end
