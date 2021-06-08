note
	description: "Memory reader/writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-08 16:26:09 GMT (Tuesday 8th June 2021)"
	revision: "20"

class
	EL_MEMORY_READER_WRITER

inherit
	EL_MEMORY_READER_WRITER_IMPLEMENTATION
		export
			{ANY} buffer, count
		end

	EL_MEMORY_STRING_READER_WRITER

	EL_READABLE
		export
			{NONE} all
		end

	EL_WRITEABLE
		rename
			write_raw_character_8 as write_character_8,
			write_raw_string_8 as write_string_8
		export
			{NONE} all
		end

create
	make, make_with_buffer

feature -- Access

	checksum: NATURAL
		local
			crc: EL_CYCLIC_REDUNDANCY_CHECK_32
		do
			create crc.make
			crc.add_data (buffer)
			Result := crc.checksum
		end

	data: MANAGED_POINTER
			-- Copy of `buffer' containing ONLY the serialized/deserialized data.
		do
			create Result.make_from_pointer (buffer.item, count)
		ensure
			valid_data_size: Result.count = count
		end

	data_version: NATURAL
		-- Version number of data if different from the default ({REAL}.zero)

	debug_out: STRING
		-- internal buffer as string
		do
			create Result.make_filled (' ', count)
			Result.area.base_address.memory_copy (buffer.item, count)
		end

feature -- Status query

	is_default_data_version: BOOLEAN
		do
			Result := data_version = 0
		end

feature -- Element change

	reset_count
		do
			count := 0
		end

	set_data_version (a_data_version: like data_version)
		do
			data_version := a_data_version
		end

	set_default_data_version
		do
			data_version := 0
		end

feature -- Basic operations

	write_to_medium (output: IO_MEDIUM)
		-- Write `buffer' to `output'
		do
			output.put_managed_pointer (buffer, 0, count)
		end

	write_to_sink (sink: EL_MEMORY_SINK)
		do
			sink.put_managed_pointer (buffer, 0, count)
		end

feature -- Read operations

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

	read_memory_block: MANAGED_POINTER
		do
			create Result.make (0)
			read_into_memory_block (Result)
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

	read_skip (n: INTEGER)
		-- skip `n' bytes
		require
			is_ready: is_ready_for_reading
		do
			count := count + n
		end

	read_to_natural_8_array (array: ARRAY [NATURAL_8])
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

feature -- Write operations

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

feature {EL_STORABLE} -- Element change

	set_count (a_count: INTEGER)
		do
			count := a_count
		end

feature {NONE} -- Implementation

	new_item: EL_STORABLE
		do
			create {EL_STORABLE_IMPL} Result.make_default
		end

end