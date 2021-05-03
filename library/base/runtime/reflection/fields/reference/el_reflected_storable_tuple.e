note
	description: "Reflected TUPLE that can be read and written to an object of type [$source EL_MEMORY_READER_WRITER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 10:26:49 GMT (Monday 3rd May 2021)"
	revision: "13"

class
	EL_REFLECTED_STORABLE_TUPLE

inherit
	EL_REFLECTED_TUPLE
		redefine
			write, set_from_memory
		end

create
	make

feature -- Basic operations

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			Tuple.read (value (a_object), memory)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			if attached value (a_object) as l_tuple then
				Tuple.write (l_tuple, writeable, Empty_string_8)
			end
		end

end