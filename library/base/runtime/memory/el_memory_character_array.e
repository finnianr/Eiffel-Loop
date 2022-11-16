note
	description: "Memory character array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

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