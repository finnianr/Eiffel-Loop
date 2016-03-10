note
	description: "Summary description for {EL_MEMORY_READER_WRITER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-23 13:51:44 GMT (Tuesday 23rd July 2013)"
	revision: "3"

class
	EL_MEMORY_READER_WRITER

inherit
	SED_MEMORY_READER_WRITER
		redefine
			make_with_buffer, read_string_32, write_string_32, check_buffer
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

	read_date: DATE
		do
			create Result.make_by_ordered_compact_date (read_integer_32)
		end

	read_string: ASTRING
		local
			str: STRING; foreign_characters: SPECIAL [CHARACTER_32]
			i, l_count: INTEGER
		do
			str := read_string_8
			l_count := read_integer_32
			create foreign_characters.make_filled ('%U', l_count)
			from i := 0 until i = l_count loop
				foreign_characters [i] := read_compressed_natural_32.to_character_32
				i := i + 1
			end
			create Result.make_from_components (str, foreign_characters)
		end

	read_string_32: STRING_32
		local
			i, l_count: INTEGER
		do
			l_count := read_integer_32
			create Result.make (l_count)
			from i := 1 until i > l_count loop
				Result.append_code (read_compressed_natural_32)
				i := i + 1
			end
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

	write_date (a_date: DATE)
		do
			write_integer_32 (a_date.ordered_compact_date)
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

	write_string (a_string: ASTRING)
		local
			i, l_count: INTEGER
		do
			write_string_8 (a_string)
			l_count := a_string.foreign_count
			write_integer_32 (l_count)
			from i := 0 until i = l_count loop
				write_compressed_natural_32 (a_string.foreign_characters.item (i).natural_32_code)
				i := i + 1
			end
		end

	write_string_32 (a_string: STRING_32)
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

feature {EL_MEMORY_READER_WRITER} -- Element change

	set_count (a_count: like count)
		do
			count := a_count
		end

feature {EL_STORABLE} -- Contract Support

	retrieved (from_count: INTEGER): like new_item
			-- See postcondition of {EL_STORABLE}.write
		local
			reader: EL_MEMORY_READER_WRITER
		do
			create reader.make_with_buffer (buffer)
			reader.set_count (from_count)
			Result := new_item
			Result.read (reader)
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
end
