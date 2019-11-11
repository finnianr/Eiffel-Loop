note
	description: "Tl string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-11 20:50:41 GMT (Monday 11th November 2019)"
	revision: "3"

class
	TL_STRING_LIST

inherit
	EL_OWNED_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_STRING_LIST_CPP_API

	ITERABLE [ZSTRING]

create
	make

feature -- Access

	arrayed: EL_ZSTRING_LIST
		do
			create Result.make (count)
			across Current as field loop
				Result.extend (field.item)
			end
		end

feature -- Measurement

	count: INTEGER
		do
			Result := cpp_size (self_ptr)
		end

feature {NONE} -- Implementation

	new_cursor: TL_STRING_LIST_ITERATION_CURSOR
		do
			create Result.make (cpp_iterator_begin (self_ptr), cpp_iterator_end (self_ptr))
		end

end
