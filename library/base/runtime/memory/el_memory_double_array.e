note
	description: "Memory double array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:03 GMT (Saturday 19th May 2018)"
	revision: "3"

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