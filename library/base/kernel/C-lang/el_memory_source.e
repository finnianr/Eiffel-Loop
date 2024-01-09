note
	description: "Memory source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 11:20:18 GMT (Monday 5th December 2022)"
	revision: "6"

deferred class
	EL_MEMORY_SOURCE

feature -- Basic operations

	read_to_managed_pointer (pointer: MANAGED_POINTER; offset, nb_bytes: INTEGER)
		require
			valid_arguments: offset + nb_bytes <= pointer.count
		do
			read_to_memory (pointer.item, offset, nb_bytes)
		end

	read_to_memory (memory: POINTER; offset, nb_bytes: INTEGER)
		deferred
		end
end