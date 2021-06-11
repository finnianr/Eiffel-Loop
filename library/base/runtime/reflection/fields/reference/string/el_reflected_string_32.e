note
	description: "Reflected field of type [$source STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-11 15:36:48 GMT (Friday 11th June 2021)"
	revision: "9"

class
	EL_REFLECTED_STRING_32

inherit
	EL_REFLECTED_STRING [STRING_32]

create
	make

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			value (a_object).wipe_out
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as str then
				memory.read_into_string_32 (str)
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string_32)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_string_32 (value (a_object))
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string_32 (value (a_object))
		end

feature {NONE} -- Implementation

	set_string (string: STRING_32; general: READABLE_STRING_GENERAL)
		do
			string.wipe_out
			if attached {ZSTRING} general as zstr then
				zstr.append_to_string_32 (string)
			else
				string.append_string_general (general)
			end
		end

end