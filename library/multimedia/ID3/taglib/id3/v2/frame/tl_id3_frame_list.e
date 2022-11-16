note
	description: "TagLib ID3 frame list `TagLib::ID3v2::FrameList'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	TL_ID3_FRAME_LIST

inherit
	EL_OWNED_CPP_OBJECT

	TL_ID3_FRAME_LIST_CPP_API

	TL_SHARED_ONCE_STRING

	ITERABLE [TL_ID3_TAG_FRAME]

create
	make, make_from_pointer

feature {NONE} -- Initialization

	make
		do
			make_from_pointer (cpp_new)
		end

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := cpp_is_empty (self_ptr)
		end

feature -- Access

	count: INTEGER
		do
			Result := cpp_size (self_ptr)
		end

	first_text: ZSTRING
		require
			not_empty: not is_empty
		do
			cpp_get_first_text (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

feature {TL_ID3_V2_TAG_FRAME_ROUTINES} -- Implementation

	new_cursor: TL_ID3_FRAME_ITERATION_CURSOR
		do
			create Result.make (cpp_iterator_begin (self_ptr), cpp_iterator_end (self_ptr))
		end

	set_from_pointer (a_ptr: POINTER)
			--
		require
			valid_object: is_attached (a_ptr)
		do
			dispose
			make_from_pointer (a_ptr)
		end

end