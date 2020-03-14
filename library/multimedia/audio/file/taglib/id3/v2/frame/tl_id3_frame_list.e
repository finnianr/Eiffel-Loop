note
	description: "Tl id3 frame list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-14 18:00:10 GMT (Saturday 14th March 2020)"
	revision: "3"

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
	make, default_create

feature -- Status query

	is_empty: BOOLEAN
		do
			Result := not is_attached (self_ptr) or else cpp_is_empty (self_ptr)
		end

feature -- Access

	first_text: ZSTRING
		require
			not_empty: not is_empty
		do
			cpp_get_first_text (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

feature {TL_ID3_V2_TAG} -- Implementation

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
			self_ptr := a_ptr
		end

end
