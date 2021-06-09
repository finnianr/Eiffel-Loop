note
	description: "Memory reader/writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-09 9:20:15 GMT (Wednesday 9th June 2021)"
	revision: "21"

class
	EL_MEMORY_READER_WRITER

inherit
	EL_MEMORY_READER_WRITER_IMPLEMENTATION
		export
			{EL_STORABLE} set_count, buffer, count
		end

	EL_MEMORY_STRING_READER_WRITER

create
	make, make_with_buffer

feature -- Read sequences

	read_into_memory_block (block: MANAGED_POINTER)

		local
			byte_count, read_count, pos: INTEGER
		do
			if attached buffer as buf then
				pos := count
				byte_count := compressed_natural_32 (buf, pos, $read_count).to_integer_32
				if read_count.to_boolean then
					pos := pos + read_count
					if pos + byte_count < buf.count then
						if block.count < byte_count then
							block.resize (byte_count)
						end
						block.item.memory_copy (buf.item + pos, byte_count)
						pos := pos + byte_count
					end
				end
				count := pos
			end
		end

	read_into_natural_8_array (array: ARRAY [NATURAL_8])
		require
			is_ready: is_ready_for_reading
		local
			pos: INTEGER
		do
			pos := count
			if attached buffer as buf and then pos + array.count < buf.count then
				buf.read_into_special_natural_8 (array.area, pos, 0, array.count)
				count := pos + array.count
			end
		end

	read_memory_block: MANAGED_POINTER
		do
			create Result.make (0)
			read_into_memory_block (Result)
		end

feature -- Write sequences

	write_bytes (value: NATURAL_8; n: INTEGER)
		require
			is_ready: is_ready_for_writing
		local
			pos, i: INTEGER
		do
			if attached big_enough_buffer (n) as buf then
				pos := count
				from i := 1 until i > n loop
					buf.put_natural_8 (value, pos)
					i := i + 1
				end
				count := pos + n
			end
		end

	write_bytes_from_medium (input: IO_MEDIUM; byte_count: INTEGER)
		-- append buffer with `nb' bytes from `input' medium
		require
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (byte_count) as buf then
				pos := count
				input.read_to_managed_pointer (buf, pos, byte_count)
				count := pos + byte_count
			end
		end

	write_bytes_from_memory (source: EL_MEMORY_SOURCE; byte_count: INTEGER)
		require
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (byte_count) as buf then
				pos := count
				source.read_to_managed_pointer (buf, pos, byte_count)
				count := pos + byte_count
			end
		end

	write_memory_block (block: MANAGED_POINTER)
		require
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			write_compressed_natural_32 (block.count.to_natural_32)
			if attached big_enough_buffer (block.count) as buf then
				pos := count;
				(buf.item + pos).memory_copy (block.item, block.count)
				count := pos + block.count
			end
		end

	write_natural_8_array (a_data: ARRAY [NATURAL_8])
		require
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (a_data.count) as buf then
				pos := count
				buf.put_special_natural_8 (a_data.area, 0, pos, a_data.count)
				count := pos + a_data.count
			end
		end

	write_sequence (a_sequence: SEQUENCE [EL_STORABLE])
		require
			is_ready: is_ready_for_writing
		do
			write_integer_32 (a_sequence.count)
			from a_sequence.start until a_sequence.after loop
				a_sequence.item.write (Current)
				a_sequence.forth
			end
		end

	write_sub_special (array: SPECIAL [CHARACTER_8]; source_index, n: INTEGER)
		require
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (n) as buf then
				pos := count
				buf.put_special_character_8 (array, source_index, pos, n)
				count := pos + n
			end
		end

	write_to_medium (output: IO_MEDIUM)
		-- Write `buffer' to `output'
		do
			output.put_managed_pointer (buffer, 0, count)
		end

	write_to_sink (sink: EL_MEMORY_SINK)
		do
			sink.put_managed_pointer (buffer, 0, count)
		end

feature -- Read other

	read_boolean: BOOLEAN
			-- Read next boolean
		require else
			is_ready: is_ready_for_reading
		do
			Result := read_natural_8.to_boolean
		end

	read_character_32: CHARACTER_32
			-- Read next 32-bits character
		require else
			is_ready: is_ready_for_reading
		do
			Result := read_natural_32.to_character_32
		end

	read_character_8: CHARACTER
			-- Read next 8-bits character
		require else
			is_ready: is_ready_for_reading
		do
			Result := read_natural_8.to_character_8
		end

	read_pointer: POINTER
			-- Read next pointer
		require else
			is_ready: is_ready_for_reading
		local
			pos: INTEGER
		do
			pos := count
			if attached buffer as buf and then pos + Pointer_bytes < buf.count then
				Result := buf.read_pointer (pos)
				count := pos + Pointer_bytes
			end
		end

feature -- Read numerics

	read_integer_8: INTEGER_8
			-- Read next integer_8
		require else
			is_ready: is_ready_for_reading
		do
			check
				correct_size: natural_8_bytes = integer_8_bytes
			end
			Result := read_natural_8.as_integer_8
		end

	read_integer_16: INTEGER_16
			-- Read next integer_16
		require else
			is_ready: is_ready_for_reading
		do
			check
				correct_size: natural_16_bytes = integer_16_bytes
			end
			Result := read_natural_16.as_integer_16
		end

	read_integer_32: INTEGER
			-- Read next integer_32
		require else
			is_ready: is_ready_for_reading
		do
			check
				correct_size: natural_32_bytes = integer_32_bytes
			end
			Result := read_natural_32.as_integer_32
		end

	read_integer_64: INTEGER_64
			-- Read next integer_64
		require else
			is_ready: is_ready_for_reading
		do
			check
				correct_size: natural_64_bytes = integer_64_bytes
			end
			Result := read_natural_64.as_integer_64
		end

	read_natural_8: NATURAL_8
			-- Read next natural_8
		require else
			is_ready: is_ready_for_reading
		local
			pos: INTEGER
		do
			pos := count
			if attached buffer as buf and then pos + Natural_8_bytes < buf.count then
				Result := buf.read_natural_8 (pos)
				count := pos + natural_8_bytes
			end
		end

	read_natural_16: NATURAL_16
			-- Read next natural_16
		require else
			is_ready: is_ready_for_reading
		local
			pos: INTEGER
		do
			pos := count
			if attached buffer as b and then pos + Natural_16_bytes < b.count then
				Result := b.read_natural_16 (pos)
				count := pos + Natural_16_bytes
			end
		end

	read_natural_32: NATURAL_32
			-- Read next natural_32
		require else
			is_ready: is_ready_for_reading
		local
			pos: INTEGER
		do
			pos := count
			if attached buffer as b and then pos + Natural_32_bytes < b.count then
				Result := b.read_natural_32 (pos)
				count := pos + Natural_32_bytes
			end
		end

	read_natural_64: NATURAL_64
			-- Read next natural_64
		require else
			is_ready: is_ready_for_reading
		local
			pos: INTEGER
		do
			pos := count
			if attached buffer as b and then pos + Natural_64_bytes < b.count then
				Result := b.read_natural_64 (pos)
				count := pos + Natural_64_bytes
			end
		end

	read_real_32: REAL_32
			-- Read next real_32
		require else
			is_ready: is_ready_for_reading
		local
			pos: INTEGER
		do
			pos := count
			if attached buffer as b and then pos + Real_32_bytes < b.count then
				Result := b.read_real_32 (pos)
				count := pos + Real_32_bytes
			end
		end

	read_real_64: REAL_64
			-- Read next real_64
		require else
			is_ready: is_ready_for_reading
		local
			pos: INTEGER
		do
			pos := count
			if attached buffer as b and then pos + Real_64_bytes < b.count then
				Result := b.read_real_64 (pos)
				count := pos + Real_64_bytes
			end
		end

feature -- Write other

	write_boolean (v: BOOLEAN)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		do
			if v then
				write_natural_8 (1)
			else
				write_natural_8 (0)
			end
		end

	write_character_32 (v: CHARACTER_32)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		do
			write_natural_32 (v.natural_32_code)
		end

	write_character_8 (v: CHARACTER_8)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		do
			write_natural_8 (v.code.to_natural_8)
		end

	write_pointer (v: POINTER)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (Pointer_bytes) as b then
				pos := count
				b.put_pointer (v, pos)
				count := pos + Pointer_bytes
			end
		end

feature -- Write numerics

	write_integer_8 (v: INTEGER_8)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		do
			check
				correct_size: Natural_8_bytes = Integer_8_bytes
			end
			write_natural_8 (v.as_natural_8)
		end

	write_integer_16 (v: INTEGER_16)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		do
			check
				correct_size: Natural_16_bytes = Integer_16_bytes
			end
			write_natural_16 (v.as_natural_16)
		end

	write_integer_32 (v: INTEGER)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		do
			check
				correct_size: Natural_32_bytes = Integer_32_bytes
			end
			write_natural_32 (v.as_natural_32)
		end

	write_integer_64 (v: INTEGER_64)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		do
			check
				correct_size: Natural_64_bytes = Integer_64_bytes
			end
			write_natural_64 (v.as_natural_64)
		end

	write_natural_8 (v: NATURAL_8)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (Natural_8_bytes) as b then
				pos := count
				b.put_natural_8 (v, pos)
				count := pos + Natural_8_bytes
			end
		end

	write_natural_16 (v: NATURAL_16)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (Natural_16_bytes) as b then
				pos := count
				b.put_natural_16 (v, pos)
				count := pos + Natural_16_bytes
			end
		end

	write_natural_32 (v: NATURAL_32)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (Natural_32_bytes) as b then
				pos := count
				b.put_natural_32 (v, pos)
				count := pos + Natural_32_bytes
			end
		end

	write_natural_64 (v: NATURAL_64)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (Natural_64_bytes) as b then
				pos := count
				b.put_natural_64 (v, pos)
				count := pos + Natural_64_bytes
			end
		end

	write_real_32 (v: REAL_32)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (Real_32_bytes) as b then
				pos := count
				b.put_real_32 (v, pos)
				count := pos + Real_32_bytes
			end
		end

	write_real_64 (v: REAL_64)
			-- Write `v'.
		require else
			is_ready: is_ready_for_writing
		local
			pos: INTEGER
		do
			if attached big_enough_buffer (Real_64_bytes) as b then
				pos := count
				b.put_real_64 (v, pos)
				count := pos + Real_64_bytes
			end
		end

end