note
	description: "Tl string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 15:49:52 GMT (Thursday   31st   October   2019)"
	revision: "1"

class
	TL_STRING_LIST

inherit
	EL_OWNED_CPP_OBJECT
		rename
			make_from_pointer as make
		end

	TL_STRING_LIST_CPP_API

	ITERABLE [TL_STRING]

create
	make

feature -- Access

	arrayed: EL_ARRAYED_LIST [TL_STRING]
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
			create Result.make (cpp_field_list_begin (self_ptr), cpp_field_list_end (self_ptr))
		end

end
