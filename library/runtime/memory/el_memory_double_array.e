note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

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
