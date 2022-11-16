note
	description: "Reflected field of type [$source IMMUTABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	EL_REFLECTED_IMMUTABLE_STRING_8

inherit
	EL_REFLECTED_STRING [IMMUTABLE_STRING_8]

create
	make

feature -- Basic operations

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached Buffer_8.empty as str then
				memory.read_into_string_8 (str)
				set_from_string_general (a_object, str)
			end
		end

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		do
			set (a_object, create {IMMUTABLE_STRING_8}.make_from_string (node.as_string_8 (False)))
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string_8)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_string_8 (value (a_object))
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string_8 (value (a_object))
		end

feature {NONE} -- Implementation

	replaced (string: IMMUTABLE_STRING_8; content: READABLE_STRING_GENERAL): IMMUTABLE_STRING_8
		do
			create Result.make_from_string (content.to_string_8)
		end

	reset (a_object: EL_REFLECTIVE)
		do
			set (a_object, Empty_string)
		end

feature {NONE} -- Constants

	Empty_string: IMMUTABLE_STRING_8
		once
			create Result.make_empty
		end
end