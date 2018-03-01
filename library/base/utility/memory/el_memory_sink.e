note
	description: "Abstraction for memory data sink"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
