note
	description: "Reflected field conforming to type ${EL_STORABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:22:07 GMT (Monday 28th April 2025)"
	revision: "20"

class
	EL_REFLECTED_STORABLE

inherit
	EL_REFLECTED_REFERENCE [EL_STORABLE]
		redefine
			is_abstract, to_string, set_from_string, set_from_memory, write, write_to_memory
		end

	EL_STORABLE_HANDLER

	EL_MODULE_BASE_64

create
	make

feature -- Access

	to_string (object: ANY): READABLE_STRING_GENERAL
		local
			l_count: INTEGER
		do
			if attached value (object) as storable then
				if attached {EL_MAKEABLE_FROM_STRING [STRING_GENERAL]} storable as makeable then
					Result := makeable.to_string
				else
					l_count := write_to_buffer (object)
					Result := Base_64.encoded_memory (Memory_buffer, l_count, True)
				end
			else
				create {STRING} Result.make_empty
			end
		end

feature -- Basic operations

	set_from_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			value (object).read (memory)
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		do
			if attached value (object) as storable then
				if attached {EL_MAKEABLE_FROM_STRING [STRING_GENERAL]} storable as makeable then
					makeable.make_from_general (string)

				elseif string.is_valid_as_string_8
					and then attached string.to_string_8 as base_64_text
					and then attached Memory_reader_writer as memory
				then
					memory.set_for_writing
					memory.reset_count
					memory.write_natural_8_array (Base_64.decoded_array (base_64_text))
					memory.set_for_reading
					memory.reset_count
					set_from_memory (object, memory)
				end
			end
		end

	write (object: ANY; writable: EL_WRITABLE)
		-- write base64 encoded string representation of data
		local
			l_count: INTEGER
		do
			l_count := write_to_buffer (object)
			Base_64.encode_to_writable (Memory_buffer, l_count, writable, True)
		end

	write_to_memory (object: ANY; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (object) as v then
				v.write (memory)
			end
		end

feature {NONE} -- Implementation

	write_to_buffer (object: ANY): INTEGER
		-- write to `Memory_buffer'
		do
			if attached Memory_reader_writer as memory then
				memory.set_for_writing
				memory.reset_count
				write_to_memory (object, memory)
				Result := memory.count
			end
		end

feature {NONE} -- Constants

	Is_abstract: BOOLEAN = True
		-- `True' if field type is deferred

	Memory_buffer: MANAGED_POINTER
		once
			create Result.make (20)
		end

	Memory_reader_writer: EL_MEMORY_READER_WRITER
		once
			create Result.make_with_buffer (Memory_buffer)
		end

end