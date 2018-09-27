note
	description: "Memory double array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

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