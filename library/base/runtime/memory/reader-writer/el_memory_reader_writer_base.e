note
	description: "[
		Implementation routines for memory buffer reader/writer class ${EL_MEMORY_READER_WRITER}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-07 16:51:20 GMT (Friday 7th February 2025)"
	revision: "15"

deferred class
	EL_MEMORY_READER_WRITER_BASE

inherit
	EL_READABLE
		export
			{NONE} all
		end

	EL_WRITABLE
		rename
			write_encoded_character_8 as write_character_8,
			write_encoded_string_8 as write_string_8
		export
			{NONE} all
		end

	PLATFORM
		rename
			Is_little_endian as Is_platform_little_endian
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make_big_endian
		do
			make_endian (False)
		ensure
			stored_as_big_endian: not stored_as_little_endian
		end

	make_endian (as_little: BOOLEAN)
			-- Initialize current to read or write from `a_medium' using a buffer of size `Default_buffer_size'
			-- and with endianness as Little if `as_little = True'
		do
			buffer_size := Default_buffer_size
			if Is_platform_little_endian = as_little then
				create buffer.make (buffer_size) -- native
			else
				-- reverse byte order for Big-endian platforms to little-endian
				create {EL_REVERSE_MANAGED_POINTER} buffer.make (buffer_size)
			end
		ensure
			correct_size: buffer.count = Default_buffer_size
			same_endian: stored_as_little_endian = as_little
		end

	make_little_endian
		do
			make_endian (True)
		ensure
			stored_as_little: stored_as_little_endian
		end

	make_with_buffer (a_buffer: like buffer)
			-- Initialize current to read or write from `a_medium' using a buffer of size `a_buffer_size'.
			-- `buffer_size' will be overriden during read operation by the value of `buffer_size' used
			-- when writing.
		require
			valid_buffer_type: not Is_platform_little_endian implies attached {EL_REVERSE_MANAGED_POINTER} a_buffer
		do
			buffer := a_buffer; buffer_size := a_buffer.count
		ensure
			buffer_set: buffer = a_buffer
			buffer_size_set: buffer_size = a_buffer.count
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

	count: INTEGER
		-- Position in `buffer' for next read/write operation

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

feature -- Status report

	is_default_data_version: BOOLEAN
		do
			Result := data_version = 0
		end

	is_for_reading: BOOLEAN
			-- Will current do a read operation?

	is_native_endian: BOOLEAN
		do
			Result := Is_platform_little_endian = stored_as_little_endian
		end

	is_ready_for_reading: BOOLEAN
			-- Is Current ready for future read operations?
		do
			Result := is_for_reading
		end

	is_ready_for_writing: BOOLEAN
			-- Is Current ready for future write operations?
		do
			Result := not is_for_reading
		end

	stored_as_little_endian: BOOLEAN
		do
			if Is_platform_little_endian then
				Result := not attached {EL_REVERSE_MANAGED_POINTER} buffer
			else
				Result := attached {EL_REVERSE_MANAGED_POINTER} buffer
			end
		end

feature -- Settings

	set_for_reading
			-- Set current for reading.
		do
			is_for_reading := True
		ensure
			is_for_reading: is_for_reading
		end

	set_for_writing
			-- Set current for writing.
		do
			is_for_reading := False
		ensure
			is_for_writing: not is_for_reading
		end

feature -- Measurement

	size_of_compressed_natural_32 (v: NATURAL_32): INTEGER
			-- Depending on value of `v', it will tell how many natural_8 will
			-- be written. Below here is the actual encoding where `x' represents
			-- a meaningful bit for `v' and the last number in parenthesis is the
			-- marker value in hexadecimal which is added to the value of `v'.
			-- 1 - For values between 0 and 127, write 0xxxxxxx (0x00).
			-- 2 - For values between 128 and 16382, write 0x10xxxxxx xxxxxxxx (0xE0).
			-- 3 - For values between 16383 and 2097150, write 0x110xxxxx xxxxxxxx xxxxxxxx (0xC0).
			-- 4 - For values between 2097151 and 268435454, write 0x1110xxx xxxxxxxx xxxxxxxx xxxxxxxx (0xE0).
			-- 5 - Otherwise write `v' as a full natural_32.
		do
				-- Perform a pseudo binary search on the 0x00004000 value
				-- so that we have less checks to do for values above 0x00004000.
				-- If have one more check for values less than 0x00000080, but
				-- experience shows that they don't occur often.
			if v < 0x00004000 then
				if v < 0x00000080 then
						-- Values between 0 and 127.
					Result := 1
				else
						-- Values between 128 and 16382.
					Result := 2
				end
			elseif v < 0x00200000 then
					-- Values between 16383 and 2097150.
				Result := 3
			elseif v < 0x10000000 then
					-- Value between 2097151 and 268435454.
				Result := 4
			else
					-- Values between 268435455 and 4294967295
				Result := 5
			end
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

feature -- Read operations

	read_compressed_natural_32: NATURAL_32
		require
			is_ready: is_ready_for_reading
		local
			read_count, pos: INTEGER
		do
			if attached buffer as buf then
				pos := count
				Result := compressed_natural_32 (buf, pos, $read_count)
				count := pos + read_count
			end
		end

	read_skip (n: INTEGER)
		-- skip `n' bytes
		require
			is_ready: is_ready_for_reading
		do
			count := count + n
		end

feature {NONE} -- Implementation

	big_enough_buffer (n: INTEGER): like buffer
			-- If there is enough space in `buffer' to read `n' bytes, do nothing.
			-- Otherwise, read/write to `medium' to free some space.
		do
			Result := buffer
			if n + count > buffer_size then
				buffer_size := (n + count) * 3 // 2
				Result.resize (buffer_size)
			end
		ensure then
			buffer_big_enough: n + count <= Result.count
		end

	compressed_natural_32 (a_buffer: MANAGED_POINTER; a_pos: INTEGER; read_count_out: POINTER): NATURAL_32
			-- Read next compressed natural_32 outputting the count of bytes read into
			-- `INTEGER' pointer `read_count_out'

			-- Depending on first natural_8 value read, it will tell how much more we need to read:
			-- 1 - Of the form 0xxxxxxx (0x00) for values between 0 and 127
			-- 2 - Of the form 10xxxxxx (0x80) for values between 128 and 16382 and one more to read.
			-- 3 - Of the form 110xxxxx (0xC0) for values between 16383 and 2097150 and 2 more to read.
			-- 4 - Of the form 1110xxxx (0xE0) for values between 2097151 and 268435454 and 3 more to read
			-- 5 - Otherwise a full natural_32 to read.
		require
			is_ready: is_ready_for_reading
		local
			n1, n2, n3, n4: NATURAL_32; pos, read_count: INTEGER
		do
			pos := a_pos
			if pos < a_buffer.count then
				n1 := a_buffer.read_natural_8 (pos)
				pos := pos + 1
				if n1 & 0x80 = 0 then
						-- Values between 0 and 127
					Result := n1
				elseif n1 & 0xC0 = 0x80 then
						-- Values between 128 and 16382
					if pos < a_buffer.count then
						n2 := a_buffer.read_natural_8 (pos)
						pos := pos + 1
						Result := ((n1 & 0x0000003F) |<< 8) | n2
					end
				elseif n1 & 0xE0 = 0xC0 then
						-- Values between 16383 and 2097150
					if pos + 1 < a_buffer.count then
						n2 := a_buffer.read_natural_8 (pos)
						n3 := a_buffer.read_natural_8 (pos + 1)
						pos := pos + 2
						Result := ((n1 & 0x0000001F) |<< 16) | (n2 |<< 8) | (n3)
					end
				elseif n1 & 0xF0 = 0xE0 then
						-- Values between 2097151 and 268435454
					if pos + 2 < a_buffer.count then
						n2 := a_buffer.read_natural_8 (pos)
						n3 := a_buffer.read_natural_8 (pos + 1)
						n4 := a_buffer.read_natural_8 (pos + 2)
						pos := pos + 3
						Result := ((n1 & 0x0000000F) |<< 24) | (n2 |<< 16) | (n3 |<< 8) | (n4)
					end
				else
						-- Values between 268435455 and 4294967295
					if pos + 3 < a_buffer.count then
						Result := a_buffer.read_natural_32 (pos)
						pos := pos + 4
					end
				end
			end
			read_count := pos - a_pos
			read_count_out.memory_copy ($read_count, Integer_32_bytes)
		end

	new_compressed_natural_32 (v: NATURAL_32; is_native: BOOLEAN): SPECIAL [NATURAL_8]
			-- Write `v' as a compressed natural_32.
			-- Depending on value of `v', it will tell how many natural_8 will
			-- be written. Below here is the actual encoding where `x' represents
			-- a meaningful bit for `v' and the last number in parenthesis is the
			-- marker value in hexadecimal which is added to the value of `v'.
			-- 1 - For values between 0 and 127, write 0xxxxxxx (0x00).
			-- 2 - For values between 128 and 16382, write 0x10xxxxxx xxxxxxxx (0xE0).
			-- 3 - For values between 16383 and 2097150, write 0x110xxxxx xxxxxxxx xxxxxxxx (0xC0).
			-- 4 - For values between 2097151 and 268435454, write 0x1110xxx xxxxxxxx xxxxxxxx xxxxxxxx (0xE0).
			-- 5 - Otherwise write `v' as a full natural_32.
		do
				-- Perform a pseudo binary search on the 0x00004000 value
				-- so that we have less checks to do for values above 0x00004000.
				-- If have one more check for values less than 0x00000080, but
				-- experience shows that they don't occur often.
			Result := Compression_buffer
			Result.wipe_out
			if v < 0x00004000 then
				if v < 0x00000080 then
						-- Values between 0 and 127.
					Result.extend (v.as_natural_8)
				else
						-- Values between 128 and 16382.
					Result.extend ((((v | 0x00008000) & 0x0000FF00) |>> 8).as_natural_8)
					Result.extend ((v & 0x000000FF).as_natural_8)
				end
			elseif v < 0x00200000 then
					-- Values between 16383 and 2097150.
				Result.extend ((((v | 0x00C00000) & 0x00FF0000) |>> 16).as_natural_8)
				Result.extend (((v & 0x0000FF00) |>> 8).as_natural_8)
				Result.extend ((v & 0x000000FF).as_natural_8)
			elseif v < 0x10000000 then
					-- Value between 2097151 and 268435454.
				Result.extend ((((v | 0xE0000000) & 0xFF000000) |>> 24).as_natural_8)
				Result.extend (((v & 0x00FF0000) |>> 16).as_natural_8)
				Result.extend (((v & 0x0000FF00) |>> 8).as_natural_8)
				Result.extend ((v & 0x000000FF).as_natural_8)
			else
					-- Values between 268435455 and 4294967295
				Result.extend (0xF0)
				if is_native then
					Result.extend (((v & 0xFF000000) |>> 24).as_natural_8)
					Result.extend (((v & 0x00FF0000) |>> 16).as_natural_8)
					Result.extend (((v & 0x0000FF00) |>> 8).as_natural_8)
					Result.extend ((v & 0x000000FF).as_natural_8)
				else
					Result.extend ((v & 0x000000FF).as_natural_8)
					Result.extend (((v & 0x0000FF00) |>> 8).as_natural_8)
					Result.extend (((v & 0x00FF0000) |>> 16).as_natural_8)
					Result.extend (((v & 0xFF000000) |>> 24).as_natural_8)
				end
			end
		end

	new_item: EL_STORABLE
		do
			create {EL_STORABLE_IMPL} Result.make_default
		end

	read_header (a_file: RAW_FILE)
		do
			a_file.read_integer
			count := a_file.last_integer
		end

	set_count (a_count: INTEGER)
		do
			count := a_count
		end

	write_compressed_natural_32 (v: NATURAL_32)
			-- Write `v' as a compressed natural_32.
			-- Depending on value of `v', it will tell how many natural_8 will
			-- be written. Below here is the actual encoding where `x' represents
			-- a meaningful bit for `v' and the last number in parenthesis is the
			-- marker value in hexadecimal which is added to the value of `v'.
			-- 1 - For values between 0 and 127, write 0xxxxxxx (0x00).
			-- 2 - For values between 128 and 16382, write 0x10xxxxxx xxxxxxxx (0xE0).
			-- 3 - For values between 16383 and 2097150, write 0x110xxxxx xxxxxxxx xxxxxxxx (0xC0).
			-- 4 - For values between 2097151 and 268435454, write 0x1110xxx xxxxxxxx xxxxxxxx xxxxxxxx (0xE0).
			-- 5 - Otherwise write `v' as a full natural_32.
		require
			is_ready: is_ready_for_writing
		local
			pos: INTEGER; compressed_count: SPECIAL [NATURAL_8]
		do
			compressed_count := new_compressed_natural_32 (v, is_native_endian)
			if attached big_enough_buffer (compressed_count.count) as buf then
				pos := count
				buf.put_special_natural_8 (compressed_count, 0, pos, compressed_count.count)
				count := pos + compressed_count.count
			end
		end

	write_header (a_file: RAW_FILE)
		do
			a_file.put_integer (count)
		end

feature {NONE} -- Internal attributes

	buffer: MANAGED_POINTER
			-- Buffer to store/fetch data from `medium'

	buffer_size: INTEGER

feature {NONE} -- Constants

	Compression_buffer: SPECIAL [NATURAL_8]
		once
			create Result.make_empty (5)
		end

	Default_buffer_size: INTEGER
		once
			Result := 500
		end

end