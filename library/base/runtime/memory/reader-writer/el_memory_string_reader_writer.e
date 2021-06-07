note
	description: "Memory string reader/writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-07 11:21:41 GMT (Monday 7th June 2021)"
	revision: "2"

deferred class
	EL_MEMORY_STRING_READER_WRITER

inherit
	EL_MEMORY_READER_WRITER_IMPLEMENTATION
		redefine
			read_string_32, write_string_32
		end

	EL_ZCODE_CONVERSION
		export
			{NONE} all
		end

	STRING_HANDLER

feature -- Measurement

	size_of_string (str: EL_READABLE_ZSTRING): INTEGER
		do
			Result := Integer_32_bytes + str.count + str.unencoded_count * Natural_32_bytes
		end

	size_of_string_32 (str: STRING_32): INTEGER
		local
			area: SPECIAL [CHARACTER_32]; i, i_final: INTEGER
		do
			Result := Integer_32_bytes
			area := str.area; i_final := str.count
			from i := 0 until i = i_final loop
				Result := Result + size_of_compressed_natural_32 (area [i].natural_32_code)
				i := i + 1
			end
		end

	size_of_string_8 (str: STRING_8): INTEGER
		do
			Result := Integer_32_bytes + str.count
		end

feature -- Read operations

	read_into_string (str: ZSTRING)
		require else
			is_ready: is_ready_for_reading
		local
			char_count: INTEGER
		do
			char_count := read_integer_32
			str.grow (char_count)
			fill_string (str, char_count)
		end

	read_into_string_32 (str: STRING_32)
		require else
			is_ready: is_ready_for_reading
		local
			char_count: INTEGER
		do
			char_count := read_integer_32
			str.grow (char_count)
			fill_string_32 (str, char_count)
		end

	read_into_string_8 (str: STRING_8)
		require else
			is_ready: is_ready_for_reading
		local
			i, char_count, read_count, pos: INTEGER; l_area: SPECIAL [CHARACTER_8]
		do
			if attached buffer as l_buffer then
				pos := count
				char_count := compressed_natural_32 (l_buffer, pos, $read_count).to_integer_32
				if read_count.to_boolean then
					pos := pos + read_count
					if pos + char_count < l_buffer.count then
						str.grow (char_count)
						l_buffer.read_into_special_character_8 (str.area, pos, 0, char_count)
						str.set_count (char_count)
						pos := pos + char_count
					end
				end
				count := pos
			end
		end

	read_string: ZSTRING
		require else
			is_ready: is_ready_for_reading
		local
			char_count: INTEGER
		do
			char_count := read_integer_32
			create Result.make (char_count)
			fill_string (Result, char_count)
		end

	read_string_32: STRING_32
		require else
			is_ready: is_ready_for_reading
		local
			char_count: INTEGER
		do
			char_count := read_integer_32
			create Result.make (char_count)
			fill_string_32 (Result, char_count)
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

feature {NONE} -- Implementation

	fill_string (str: ZSTRING; char_count: INTEGER)
		require
			valid_string: str.is_empty and then char_count <= str.capacity
		local
			i, buffer_count, pos: INTEGER; l_area: SPECIAL [CHARACTER]; c: CHARACTER
			unencoded_buffer: EL_UNENCODED_CHARACTERS_BUFFER; done: BOOLEAN
			code: NATURAL
		do
			l_area := str.area
			unencoded_buffer := str.empty_unencoded_buffer
			if attached buffer as l_buffer then
				buffer_count := l_buffer.count
				pos := count

				from i := 0 until done or else i = char_count loop
					if pos + Character_8_bytes < buffer_count then
						c := l_buffer.read_character (pos)
						pos := pos + Character_8_bytes
						l_area [i] := c
						if c = Unencoded_character then
							if pos + Natural_32_bytes < buffer_count then
								code := l_buffer.read_natural_32 (pos)
								pos := pos + Natural_32_bytes
								unencoded_buffer.extend (code, i + 1)
							else
								done := True
							end
						end
						i := i + 1
					else
						done := True
					end
				end
				l_area [i] := '%U'
				str.set_count (i)
				str.set_unencoded_from_buffer (unencoded_buffer)
				count := pos
			end
		ensure
			valid_str: str.is_valid
		end

	fill_string_32 (str: STRING_32; a_count: INTEGER)
		local
			i, read_count, pos: INTEGER; l_area: SPECIAL [CHARACTER_32]; code: NATURAL
			done: BOOLEAN
		do
			if attached buffer as l_buffer then
				l_area := str.area; pos := count
				from i := 0 until done or else i = a_count loop
					code := compressed_natural_32 (l_buffer, pos, $read_count)
					if read_count.to_boolean then
						l_area [i] := code.to_character_32
						pos := pos + read_count
						i := i + 1
					else
						done := True
					end
				end
				str.set_count (i)
				count := pos
			end
		end

feature -- Write operations

	write_string (a_string: EL_READABLE_ZSTRING)
		require else
			valid_string: a_string.is_valid
		local
			i, l_count, pos: INTEGER; l_area: SPECIAL [CHARACTER]
			unencoded: like read_string.unencoded_indexable
			c: CHARACTER
		do
			check_buffer (size_of_string (a_string))

			unencoded := a_string.unencoded_indexable
			pos := count

			l_count := a_string.count; l_area := a_string.area

			if attached buffer as buf then
				buf.put_natural_32 (l_count.to_natural_32, pos)
				pos := pos + Natural_32_bytes

				from i := 0 until i = l_count loop
					c := l_area [i]
					buf.put_character (c, pos)
					pos := pos + Character_8_bytes

					if c = Unencoded_character then
						buf.put_natural_32 (unencoded.code (i + 1), pos)
						pos := pos + Natural_32_bytes
					end
					i := i + 1
				end
			end
			count := pos
		end

	write_string_32 (str: STRING_32)
		local
			i, char_count, pos: INTEGER; compressed_32: like new_compressed_natural_32
		do
			char_count := str.count
			check_buffer (size_of_string_32 (str))
			pos := count
			if attached buffer as l_buffer then
				l_buffer.put_integer_32 (char_count, pos)
				pos := pos + Integer_32_bytes
				from i := 1 until i > char_count loop
					compressed_32 := new_compressed_natural_32 (str.code (i))
					l_buffer.put_special_natural_8 (compressed_32, 0, pos, compressed_32.count)
					pos := pos + compressed_32.count
					i := i + 1
				end
			end
			count := pos
		end
end