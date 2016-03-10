note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

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
