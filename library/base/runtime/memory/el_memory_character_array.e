note
	description: "Memory character array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:03 GMT (Saturday 19th May 2018)"
	revision: "3"

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