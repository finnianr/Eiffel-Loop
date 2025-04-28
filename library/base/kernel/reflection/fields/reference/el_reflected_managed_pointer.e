note
	description: "Reflected field of type ${MANAGED_POINTER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:21:58 GMT (Monday 28th April 2025)"
	revision: "8"

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

	to_string (object: ANY): STRING
		do
			if attached value (object) as pointer then
				Result := Base_64.encoded_memory (pointer, pointer.count, True)
			else
				create Result.make_empty
			end
		end

feature -- Basic operations

	append_to_string (object: ANY; str: ZSTRING)
		do
			str.append_raw_string_8 (to_string (object))
		end

	reset (object: ANY)
		do
			if attached value (object) as pointer then
				pointer.resize (0)
			end
		end

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as pointer then
				memory.read_into_memory_block (pointer)
			end
		end

	set_from_readable (object: ANY; readable: EL_READABLE)
		do
			set_from_string_8 (object, readable.read_string_8)
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		do
			if attached {STRING} string as str_8 then
				set_from_string_8 (object, str_8)
			else
				set_from_string_8 (object, Buffer_8.copied_general (string))
			end
		end

	set_from_string_8 (object: ANY; base_64_encoded: STRING)
		local
			area: SPECIAL [NATURAL_8]
		do
			if attached value (object) as pointer then
				area := Base_64.decoded_special (base_64_encoded)
				pointer.resize (area.count)
				pointer.put_special_natural_8 (area, 0, 0, area.count)
			end
		end

	write (object: ANY; writable: EL_WRITABLE)
		do
			if attached value (object) as pointer then
				Base_64.encode_to_writable (pointer, pointer.count, writable, True)
			end
		end

	write_to_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as pointer then
				memory.write_memory_block (pointer)
			end
		end

end