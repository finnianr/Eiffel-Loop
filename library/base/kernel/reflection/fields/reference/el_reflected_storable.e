note
	description: "Reflected field conforming to type [$source EL_STORABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 7:21:45 GMT (Monday 12th December 2022)"
	revision: "13"

class
	EL_REFLECTED_STORABLE

inherit
	EL_REFLECTED_REFERENCE [EL_STORABLE]
		redefine
			 to_string, set_from_string, set_from_memory, write, write_to_memory
		end

	EL_MODULE_BASE_64

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		local
			l_value: EL_STORABLE
		do
			l_value :=  value (a_object)
			if attached {EL_MAKEABLE_FROM_STRING [STRING_GENERAL]} l_value as makeable then
				Result := makeable.to_string
			else
				Result := l_value.out
			end
		end

feature -- Basic operations

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			value (a_object).read (memory)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached {EL_MAKEABLE_FROM_STRING [STRING_GENERAL]} value (a_object) as makeable then
				makeable.make_from_general (string)
			end
		end

	write (a_object: EL_REFLECTIVE; writable: EL_WRITABLE)
		-- write base64 encoded string representation of data
		do
			if attached Memory_reader_writer as memory then
				memory.set_for_writing
				memory.reset_count
				write_to_memory (a_object, memory)
				Base_64.encode_to_writable (Memory_buffer, memory.count, writable)
			end
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as v then
				v.write (memory)
			end
		end

feature {NONE} -- Constants

	Memory_reader_writer: EL_MEMORY_READER_WRITER
		once
			create Result.make_with_buffer (Memory_buffer)
		end

	Memory_buffer: MANAGED_POINTER
		once
			create Result.make (20)
		end

end