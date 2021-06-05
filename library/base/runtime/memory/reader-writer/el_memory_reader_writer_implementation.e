note
	description: "Implemenation routines for class [$source EL_MEMORY_STRING_READER_WRITER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-05 17:29:36 GMT (Saturday 5th June 2021)"
	revision: "1"

class
	EL_MEMORY_READER_WRITER_IMPLEMENTATION

inherit
	SED_MEMORY_READER_WRITER
		redefine
			make_with_buffer, check_buffer
		end

	PLATFORM
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make_with_buffer (a_buffer: like buffer)
			-- Initialize current to read or write from `a_medium' using a buffer of size `a_buffer_size'.
			-- `buffer_size' will be overriden during read operation by the value of `buffer_size' used
			-- when writing.
		do
			Precursor (a_buffer)
			is_little_endian_storable := True
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

feature {NONE} -- Implementation

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

	compressed_natural_32 (
		a_buffer: MANAGED_POINTER; a_pos: INTEGER; little_endian: BOOLEAN; read_count_out: POINTER
	): NATURAL_32
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
						if little_endian then
							Result := a_buffer.read_natural_32_le (pos)
						else
							Result := a_buffer.read_natural_32_be (pos)
						end
						pos := pos + 4
					end
				end
			end
			read_count := pos - a_pos
			read_count_out.memory_copy ($read_count, Integer_32_bytes)
		end

	new_compressed_natural_32 (v: NATURAL_32; little_endian: BOOLEAN): SPECIAL [NATURAL_8]
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
				if Is_little_endian = little_endian then
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

feature {NONE} -- Constants

	Compression_buffer: SPECIAL [NATURAL_8]
		once
			create Result.make_empty (5)
		end
end