note
	description: "Reflected field of type ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-02 12:20:01 GMT (Friday 2nd February 2024)"
	revision: "15"

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

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		do
			if is_value_cached then
				set (a_object, node.as_string_32 (False))

			elseif attached value (a_object) as str_32 then
				node.set_32 (str_32)
			else
				set (a_object, node.as_string_32 (True))
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string_32)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_string_32 (value (a_object))
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string_32 (value (a_object))
		end

feature {NONE} -- Implementation

	replaced (str: STRING_32; content: READABLE_STRING_GENERAL): STRING_32
		local
			s: EL_STRING_32_ROUTINES
		do
			Result := str
			s.replace (str, content)
		end

	strict_type_id: INTEGER
		-- type that matches generator name suffix EL_REFLECTED_*
		do
			Result := ({STRING_32}).type_id
		end

end