note
	description: "Abstraction for memory data sink"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	EL_MEMORY_SINK

feature -- Basic operations

	put_managed_pointer (pointer: MANAGED_POINTER; offset, nb_bytes: INTEGER)
		require
			valid_arguments: offset + nb_bytes <= pointer.count
		do
			put_memory (pointer.item, offset, nb_bytes)
		end

	put_memory (memory: POINTER; offset, nb_bytes: INTEGER)
		deferred
		end

end