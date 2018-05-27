note
	description: "Memory reader writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "9"

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
			create crc
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

	read_date: DATE
		do
			create Result.make_by_ordered_compact_date (read_integer_32)
		end

	read_date_time: DATE_TIME
		local
			l_date: DATE
		do
			l_date := read_date
			create Result.make_by_date_time (l_date, read_time)
		end

	read_string: ZSTRING
		local
			i, l_count: INTEGER; l_area: like read_string.area; c: CHARACTER
			extendible_unencoded: EL_EXTENDABLE_UNENCODED_CHARACTERS
		do
			l_count := read_integer_32
			create Result.make (l_count)
			if l_count <= buffer.count - count then
				l_area := Result.area
				extendible_unencoded := Result.extendible_unencoded
				from i := 0 until i = l_count loop
					c := read_character_8
					l_area [i] := c
					if c = Unencoded_character then
						extendible_unencoded.extend (read_natural_32, i + 1)
					end
					i := i + 1
				end
				l_area [i] := c
				Result.set_count (l_count)
				Result.set_unencoded_area (extendible_unencoded.area_copy)
			end
		end

	read_string_32: STRING_32
		local
			i, l_count: INTEGER
		do
			l_count := read_integer_32
			create Result.make (l_count)
			if l_count <= buffer.count - count then
				from i := 1 until i > l_count loop
					Result.append_code (read_compressed_natural_32)
					i := i + 1
				end
			end
		end

	read_time: TIME
		do
			create Result.make_by_compact_time (read_integer_32)
		end

	read_to_natural_8_array (array: ARRAY [NATURAL_8])
		do
			check_buffer (array.count)
			buffer.read_into_special_natural_8 (array.area, count, 0, array.count)
			count := count + array.count
		end

	read_to_string_8 (str: STRING; n: INTEGER)
		-- set the contents of `str' with `n' characters
		do
			str.grow (n); str.set_count (n)
			check_buffer (n)
			buffer.read_into_special_character_8 (str.area, count, 0, n)
			count := count + n
		end

feature -- Write operations

	write_date (a_date: DATE)
		do
			write_integer_32 (a_date.ordered_compact_date)
		end

	write_date_time (date_time: DATE_TIME)
		do
			write_date (date_time.date)
			write_time (date_time.time)
		end

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
			interval_index: like read_string.unencoded_interval_index
			c: CHARACTER
		do
			interval_index := a_string.unencoded_interval_index
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

	write_time (time: TIME)
		do
			write_integer_32 (time.compact_time)
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

feature {NONE} -- Constants

	Unencoded_character: CHARACTER = '%/026/'

end
