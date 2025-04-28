note
	description: "Reflected field of type ${STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:22:42 GMT (Monday 28th April 2025)"
	revision: "17"

class
	EL_REFLECTED_STRING_32

inherit
	EL_REFLECTED_STRING [STRING_32]

create
	make

feature -- Basic operations

	reset (object: ANY)
		do
			value (object).wipe_out
		end

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as str then
				memory.read_into_string_32 (str)
			end
		end

	set_from_node (object: ANY; node: EL_STRING_NODE)
		do
			if is_value_cached then
				set (object, node.as_string_32 (False))

			elseif attached value (object) as str_32 then
				node.set_32 (str_32)
			else
				set (object, node.as_string_32 (True))
			end
		end

	set_from_readable (object: ANY; readable: EL_READABLE)
		do
			set (object, readable.read_string_32)
		end

	write (object: ANY; writeable: EL_WRITABLE)
		do
			writeable.write_string_32 (value (object))
		end

	write_to_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string_32 (value (object))
		end

feature {NONE} -- Implementation

	replaced (str: STRING_32; content: READABLE_STRING_GENERAL): STRING_32
		do
			Result := str
			super_32 (str).replace (content)
		end

	strict_type_id: INTEGER
		-- type that matches generator name suffix EL_REFLECTED_*
		do
			Result := ({STRING_32}).type_id
		end

end