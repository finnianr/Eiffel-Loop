note
	description: "Tl string list iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	TL_STRING_LIST_ITERATION_CURSOR

inherit
	EL_CPP_STD_ITERATION_CURSOR [ZSTRING]

	TL_STRING_LIST_ITERATOR_CPP_API

	TL_SHARED_ONCE_STRING

create
	make

feature -- Access

	item: ZSTRING
		do
			cpp_get_item (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

end