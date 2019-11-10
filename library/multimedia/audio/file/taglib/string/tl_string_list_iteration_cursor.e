note
	description: "Tl string list iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-31 15:02:51 GMT (Thursday 31st October 2019)"
	revision: "1"

class
	TL_STRING_LIST_ITERATION_CURSOR

inherit
	EL_CPP_STD_ITERATION_CURSOR [TL_STRING]

	TL_STRING_LIST_ITERATOR_CPP_API

create
	make

feature -- Access

	item: TL_STRING
		do
			create Result.make (cpp_item (self_ptr))
		end

end
