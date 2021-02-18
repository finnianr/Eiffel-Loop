note
	description: "Memory reader/writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-18 13:00:09 GMT (Thursday 18th February 2021)"
	revision: "17"

class
	EL_MEMORY_READER_WRITER

inherit
	SED_MEMORY_READER_WRITER
		redefine
			make_with_buffer, read_string_32, write_string_32, check_buffer
		end

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

	STRING_HANDLER

create
	make, make_with_buffer

feature {NONE} -- Initialization

	make_with_buffer (a_buffer: like buffer)
			-- Initialize current to read or write from `a_medium' using a buffer of size `a_buffer_size'.
			-- `buffer_size' will be overriden during read operation by the value of `buffer_size' used
			-- when writing.
		do
			Precursor (a_buffer)
			is_little_endian_storable := True
		end

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

feature -- Measurement

	size_of_string (str: ZSTRING): INTEGER
		do
			Result := {PLATFORM}.Integer_32_bytes + str.count + str.unencoded_count * {PLATFORM}.Natural_32_bytes
		end

	size_of_string_32 (str: STRING_32): INTEGER
		do
			Result := {PLATFORM}.Integer_32_bytes + str.count * {PLATFORM}.Natural_32_bytes
		end

	size_of_string_8 (str: STRING_8): INTEGER
		do
			Result := {PLATFORM}.Integer_32_bytes + str.count
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

	read_into_string (str: ZSTRING)
		require else
			is_ready: is_ready_for_reading
		local
			l_count: INTEGER
		do
			l_count := read_integer_32
			str.grow (l_count)
			fill_string (str, l_count)
		end

	read_into_string_32 (str: STRING_32)
		require else
			is_ready: is_ready_for_reading
		local
			l_count: INTEGER
		do
			l_count := read_integer_32
			str.grow (l_count)
			fill_string_32 (str, l_count)
		end

	read_into_string_8 (str: STRING_8)
		require else
			is_ready: is_ready_for_reading
		local
			i, l_count: INTEGER; l_area: SPECIAL [CHARACTER_8]
		do
			l_count := read_compressed_natural_32.to_integer_32
			str.grow (l_count)
			l_area := str.area
			from i := 0 until i = l_count loop
				l_area.put (read_character_8, i)
				i := i + 1
			end
			str.set_count (l_count)
		end

	read_string: ZSTRING
		require else
			is_ready: is_ready_for_reading
		local
			l_count: INTEGER
		do
			l_count := read_integer_32
			create Result.make (l_count)
			fill_string (Result, l_count)
		end

	read_string_32: STRING_32
		require else
			is_ready: is_ready_for_reading
		local
			l_count: INTEGER
		do
			l_count := read_integer_32
			create Result.make (l_count)
			fill_string_32 (Result, l_count)
		end

	read_to_natural_8_array (array: ARRAY [NATURAL_8])
		require
			is_ready: is_ready_for_reading
		do
			check_buffer (array.count)
			buffer.read_into_special_natural_8 (array.area, count, 0, array.count)
			count := count + array.count
		end

	read_to_string_8 (str: STRING; n: INTEGER)
		-- set the contents of `str' with `n' characters
		require
			is_ready: is_ready_for_reading
		do
			str.grow (n); str.set_count (n)
			check_buffer (n)
			buffer.read_into_special_character_8 (str.area, count, 0, n)
			count := count + n
		end

feature -- Write operations

	write_bytes (value: NATURAL_8; n: INTEGER)
		local
			l_pos, i: INTEGER
		do
			check_buffer (n)
			l_pos := count
			from i := 1 until i > n loop
				buffer.put_natural_8 (value, l_pos)
				l_pos := l_pos + 1
				i := i + 1
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

	write_natural_8_array (a_data: ARRAY [NATURAL_8])
		local
			l_pos, l_data_size: INTEGER
		do
			l_data_size := {PLATFORM}.natural_8_bytes * a_data.count
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

	write_string (a_string: EL_READABLE_ZSTRING)
		local
			i, l_count: INTEGER; l_area: like read_string.area
			interval_index: like read_string.unencoded_indexable
			c: CHARACTER
		do
			interval_index := a_string.unencoded_indexable
			l_count := a_string.count; l_area := a_string.area
			write_integer_32 (l_count)
			from i := 0 until i = l_count loop
				c := l_area [i]
				write_character_8 (c)
				if c = Unencoded_character then
					write_natural_32 (interval_index.code (i + 1))
				end
				i := i + 1
			end
		end

	write_string_32 (a_string: READABLE_STRING_32)
		local
			i, l_count: INTEGER
		do
			l_count := a_string.count
			write_integer_32 (l_count)
			from i := 1 until i > l_count loop
				write_compressed_natural_32 (a_string.code (i))
				i := i + 1
			end
		end

	write_sub_special (array: SPECIAL [CHARACTER_8]; source_index, n: INTEGER)
		local
			l_pos, l_data_size: INTEGER
		do
			l_data_size := {PLATFORM}.Character_8_bytes * n
			check_buffer (l_data_size)
			l_pos := count
			buffer.put_special_character_8 (array, source_index, l_pos, n)
			l_pos := l_pos + l_data_size
			count := l_pos
		end

feature {EL_STORABLE} -- Element change

	set_count (a_count: like count)
		do
			count := a_count
		end

feature {NONE} -- Buffer update

	check_buffer (n: INTEGER)
			-- If there is enough space in `buffer' to read `n' bytes, do nothing.
			-- Otherwise, read/write to `medium' to free some space.
		do
			if n + count > buffer_size then
				buffer_size := (n + count) * 3 // 2
				buffer.resize (buffer_size)
			end
		ensure then
			buffer_big_enough: n + count <= buffer.count
		end

feature {NONE} -- Implementation

	new_item: EL_STORABLE
		do
			create {EL_STORABLE_IMPL} Result.make_default
		end

	fill_string (str: ZSTRING; a_count: INTEGER)
		local
			i: INTEGER; l_area: like read_string.area; c: CHARACTER
			unencoded_buffer: EL_UNENCODED_CHARACTERS_BUFFER
		do
			if a_count <= buffer.count - count then
				l_area := str.area
				unencoded_buffer := str.empty_unencoded_buffer
				from i := 0 until i = a_count loop
					c := read_character_8
					l_area [i] := c
					if c = Unencoded_character then
						unencoded_buffer.extend (read_natural_32, i + 1)
					end
					i := i + 1
				end
				l_area [i] := '%U'
				str.set_count (a_count)
				str.set_unencoded_from_buffer (unencoded_buffer)
			end
		ensure
			valid_str: str.is_valid
		end

	fill_string_32 (str: STRING_32; a_count: INTEGER)
		local
			i: INTEGER; l_area: SPECIAL [CHARACTER_32]
		do
			if a_count <= buffer.count - count then
				l_area := str.area
				from i := 0 until i = a_count loop
					l_area.put (read_compressed_natural_32.to_character_32, i)
					i := i + 1
				end
				str.set_count (a_count)
			end
		end

feature {NONE} -- Constants

	Unencoded_character: CHARACTER = '%/026/'

end