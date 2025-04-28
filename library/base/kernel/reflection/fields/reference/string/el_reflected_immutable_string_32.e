note
	description: "Reflected field of type ${IMMUTABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:22:53 GMT (Monday 28th April 2025)"
	revision: "18"

class
	EL_REFLECTED_IMMUTABLE_STRING_32

inherit
	EL_REFLECTED_STRING [IMMUTABLE_STRING_32]

create
	make

feature -- Basic operations

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached Buffer_32.empty as str then
				memory.read_into_string_32 (str)
				set_from_string_general (object, str)
			end
		end

	set_from_node (object: ANY; node: EL_STRING_NODE)
		do
			set (object, create {IMMUTABLE_STRING_32}.make_from_string (node.as_string_8 (False)))
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

	replaced (string: IMMUTABLE_STRING_32; content: READABLE_STRING_GENERAL): IMMUTABLE_STRING_32
		do
			if attached {ZSTRING} content as zstr then
				Result := zstr.to_immutable_32
			else
				create Result.make_from_string (content.to_string_32)
			end
		end

	reset (object: ANY)
		do
			set (object, Empty_string)
		end

	strict_type_id: INTEGER
		-- type that matches generator name suffix EL_REFLECTED_*
		do
			Result := ({IMMUTABLE_STRING_32}).type_id
		end

feature {NONE} -- Constants

	Empty_string: IMMUTABLE_STRING_32
		once
			create Result.make_empty
		end

end