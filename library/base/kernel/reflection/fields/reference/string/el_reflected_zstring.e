note
	description: "Reflected field of type ${EL_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "14"

class
	EL_REFLECTED_ZSTRING

inherit
	EL_REFLECTED_STRING [ZSTRING]
		redefine
			append_to_string
		end

create
	make

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append (v)
			end
		end

	reset (a_object: EL_REFLECTIVE)
		do
			value (a_object).wipe_out
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as str then
				memory.read_into_string (str)
			end
		end

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		do
			if is_value_cached then
				set (a_object, node.as_string (False))

			elseif attached value (a_object) as str then
				node.set (str)
			else
				set (a_object, node.as_string (True))
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITABLE)
		do
			writeable.write_string (value (a_object))
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string (value (a_object))
		end

feature {NONE} -- Implementation

	replaced (str: ZSTRING; general: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := str
			str.wipe_out
			str.append_string_general (general)
		end

end