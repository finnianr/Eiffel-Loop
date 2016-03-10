note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

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
