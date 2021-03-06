note
	description: "Reflected field of type [$source MANAGED_POINTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-11 16:15:05 GMT (Friday 11th June 2021)"
	revision: "3"

class
	EL_REFLECTED_MANAGED_POINTER

inherit
	EL_REFLECTED_REFERENCE [MANAGED_POINTER]
		redefine
			append_to_string, reset, set_from_readable, set_from_memory, set_from_string,
			to_string, write, write_to_memory
		end

	EL_MODULE_BASE_64

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): STRING
		local
			area: SPECIAL [NATURAL_8]
		do
			if attached value (a_object) as block then
				create area.make_filled (0, block.count)
				area.base_address.memory_copy (block.item, block.count)
				Result := Base_64.encoded_special (area)
			else
				create Result.make_empty
			end
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			str.append_raw_string_8 (to_string (a_object))
		end

	reset (a_object: EL_REFLECTIVE)
		do
			value (a_object).resize (0)
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as block then
				memory.read_into_memory_block (block)
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set_from_string_8 (a_object, readable.read_string_8)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached {STRING} string as str_8 then
				set_from_string_8 (a_object, str_8)
			else
				set_from_string_8 (a_object, Buffer_8.copied_general (string))
			end
		end

	set_from_string_8 (a_object: EL_REFLECTIVE; string: STRING)
		local
			area: SPECIAL [NATURAL_8]
		do
			if attached value (a_object) as block then
				area := Base_64.decoded_special (string)
				block.resize (area.count)
				block.put_special_natural_8 (area, 0, 0, area.count)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_raw_string_8 (to_string (a_object))
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as block then
				memory.write_memory_block (block)
			end
		end

end