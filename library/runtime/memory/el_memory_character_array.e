note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_MEMORY_CHARACTER_ARRAY

inherit
	EL_MEMORY_ARRAY [CHARACTER]
		rename
			character_bytes as item_bytes,
			put_character as put_memory,
			read_character as read_memory
		end

create
	make

end
