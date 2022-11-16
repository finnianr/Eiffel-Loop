note
	description: "Memory double array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_MEMORY_DOUBLE_ARRAY

inherit
	EL_MEMORY_ARRAY [DOUBLE]
		rename
			double_bytes as item_bytes,
			put_double as put_memory,
			read_double as read_memory
		end

create
	make

end