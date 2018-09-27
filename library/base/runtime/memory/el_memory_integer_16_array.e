note
	description: "Memory integer 16 array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_MEMORY_INTEGER_16_ARRAY

inherit
	EL_MEMORY_ARRAY [INTEGER_16]
		rename
			integer_16_bytes as item_bytes,
			put_integer_16 as put_memory,
			read_integer_16 as read_memory
		end

create
	make

end