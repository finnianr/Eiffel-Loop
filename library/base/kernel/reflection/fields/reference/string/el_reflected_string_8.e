note
	description: "Reflected field of type [$source STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 6:36:25 GMT (Monday 12th December 2022)"
	revision: "11"

class
	EL_REFLECTED_STRING_8

inherit
	EL_REFLECTED_STRING [STRING_8]

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
				memory.read_into_string_8 (str)
			end
		end

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		do
			set (a_object, node.as_string_8 (not is_value_cached))
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string_8)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_string_8 (value (a_object))
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string_8 (value (a_object))
		end

feature {NONE} -- Implementation

	replaced (str: STRING_8; general: READABLE_STRING_GENERAL): STRING_8
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := str
			s.replace (str, general)
		end

end