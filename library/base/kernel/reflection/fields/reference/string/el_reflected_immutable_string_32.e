note
	description: "Reflected field of type ${IMMUTABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 11:27:21 GMT (Sunday 25th August 2024)"
	revision: "16"

class
	EL_REFLECTED_IMMUTABLE_STRING_32

inherit
	EL_REFLECTED_STRING [IMMUTABLE_STRING_32]
		rename
			Empty_string as Empty_zstring
		end

create
	make

feature -- Basic operations

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached Buffer_32.empty as str then
				memory.read_into_string_32 (str)
				set_from_string_general (a_object, str)
			end
		end

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		do
			set (a_object, create {IMMUTABLE_STRING_32}.make_from_string (node.as_string_8 (False)))
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

	replaced (string: IMMUTABLE_STRING_32; content: READABLE_STRING_GENERAL): IMMUTABLE_STRING_32
		do
			if attached {ZSTRING} content as zstr then
				Result := zstr.to_immutable_32
			else
				create Result.make_from_string (content.to_string_32)
			end
		end

	reset (a_object: EL_REFLECTIVE)
		do
			set (a_object, Empty_string)
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