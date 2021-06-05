note
	description: "Memory reader/writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-05 14:49:17 GMT (Saturday 5th June 2021)"
	revision: "19"

class
	EL_MEMORY_READER_WRITER

inherit
	EL_MEMORY_READER_WRITER_IMPLEMENTATION
		undefine
			read_string_32, write_string_32
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

	skip (n: INTEGER)
		-- skip `n' bytes
		do
			check_buffer (n)
			count := count + n
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

	read_memory_buffer: MANAGED_POINTER
		do
			create Result.make (read_integer_32)
		end

	read_to_natural_8_array (array: ARRAY [NATURAL_8])
		require
			is_ready: is_ready_for_reading
		do
			check_buffer (array.count)
			buffer.read_into_special_natural_8 (array.area, count, 0, array.count)
			count := count + array.count
		end

feature -- Write operations

	write_bytes (value: NATURAL_8; n: INTEGER)
		local
			l_pos, i: INTEGER
		do
			check_buffer (n)
			l_pos := count
			if attached buffer as l_buffer then
				from i := 1 until i > n loop
					l_buffer.put_natural_8 (value, l_pos)
					l_pos := l_pos + 1
					i := i + 1
				end
			end
			count := l_pos
		end

	write_bytes_from_medium (input: IO_MEDIUM; nb: INTEGER)
		-- append buffer with `nb' bytes from `input' medium
		do
			check_buffer (nb)
			input.read_to_managed_pointer (buffer, count, nb)
			count := count + nb
		end

	write_bytes_from_memory (source: EL_MEMORY_SOURCE; nb: INTEGER)
		do
			check_buffer (nb)
			source.read_to_managed_pointer (buffer, count, nb)
			count := count + nb
		end

	write_memory_buffer (a_buffer: MANAGED_POINTER)
		do
			write_integer_32 (a_buffer.count)
			check_buffer (a_buffer.count)
			(buffer.item + count).memory_copy (a_buffer.item, a_buffer.count)
			count := count + a_buffer.count
		end

	write_natural_8_array (a_data: ARRAY [NATURAL_8])
		local
			l_pos, l_data_size: INTEGER
		do
			l_data_size := natural_8_bytes * a_data.count
			check_buffer (l_data_size)
			l_pos := count
			buffer.put_array (a_data, l_pos)
			l_pos := l_pos + l_data_size
			count := l_pos
		end

	write_sequence (a_sequence: SEQUENCE [EL_STORABLE])
		do
			write_integer_32 (a_sequence.count)
			from a_sequence.start until a_sequence.after loop
				a_sequence.item.write (Current)
				a_sequence.forth
			end
		end

	write_sub_special (array: SPECIAL [CHARACTER_8]; source_index, n: INTEGER)
		local
			l_pos, l_data_size: INTEGER
		do
			l_data_size := Character_8_bytes * n
			check_buffer (l_data_size)
			l_pos := count
			buffer.put_special_character_8 (array, source_index, l_pos, n)
			l_pos := l_pos + l_data_size
			count := l_pos
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