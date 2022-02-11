note
	description: "Read/write strings from/to a memory buffer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 19:32:40 GMT (Friday 11th February 2022)"
	revision: "5"

deferred class
	EL_MEMORY_STRING_READER_WRITER

inherit
	EL_MEMORY_READER_WRITER_IMPLEMENTATION

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
			char_count, read_count, pos: INTEGER
		do
			if attached buffer as buf then
				pos := count
				char_count := compressed_natural_32 (buf, pos, $read_count).to_integer_32
				if read_count.to_boolean then
					pos := pos + read_count
					if pos + char_count < buf.count then
						str.grow (char_count)
						buf.read_into_special_character_8 (str.area, pos, 0, char_count)
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

	read_string_8: STRING
			-- Read next 8-bits sequence of character
		require else
			is_ready: is_ready_for_reading
		do
			create Result.make (0)
			read_into_string_8 (Result)
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
		local
			pos: INTEGER
		do
			str.grow (n); str.set_count (n)
			pos := count
			if attached buffer as buf and then pos + n < buf.count then
				buffer.read_into_special_character_8 (str.area, pos, 0, n)
				count := pos + n
			end
		end

feature {NONE} -- Implementation

	fill_string (str: ZSTRING; char_count: INTEGER)
		require
			valid_string: str.is_empty and then char_count <= str.capacity
		local
			i, buffer_count, pos: INTEGER; area: SPECIAL [CHARACTER]; c: CHARACTER
			unencoded_buffer: EL_UNENCODED_CHARACTERS_BUFFER; done: BOOLEAN
			code: NATURAL
		do
			area := str.area
			unencoded_buffer := str.empty_unencoded_buffer
			if attached buffer as buf then
				buffer_count := buf.count
				pos := count

				from i := 0 until done or else i = char_count loop
					if pos + Character_8_bytes < buffer_count then
						c := buf.read_character (pos)
						pos := pos + Character_8_bytes
						area [i] := c
						if c = Substitute then
							if pos + Natural_32_bytes < buffer_count then
								code := buf.read_natural_32 (pos)
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
				area [i] := '%U'
				str.set_count (i)
				str.set_unencoded_from_buffer (unencoded_buffer)
				count := pos
			end
		ensure
			valid_str: str.is_valid
		end

	fill_string_32 (str: STRING_32; a_count: INTEGER)
		local
			i, read_count, pos: INTEGER; area: SPECIAL [CHARACTER_32]; code: NATURAL
			done: BOOLEAN
		do
			if attached buffer as buf then
				area := str.area; pos := count
				from i := 0 until done or else i = a_count loop
					code := compressed_natural_32 (buf, pos, $read_count)
					if read_count.to_boolean then
						area [i] := code.to_character_32
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
			i, l_count, pos: INTEGER; area: SPECIAL [CHARACTER]
			unencoded: like read_string.unencoded_indexable
			c: CHARACTER
		do
			unencoded := a_string.unencoded_indexable
			l_count := a_string.count; area := a_string.area

			if attached big_enough_buffer (size_of_string (a_string)) as buf then
				pos := count
				buf.put_natural_32 (l_count.to_natural_32, pos)
				pos := pos + Natural_32_bytes

				from i := 0 until i = l_count loop
					c := area [i]
					buf.put_character (c, pos)
					pos := pos + Character_8_bytes

					if c = Substitute then
						buf.put_natural_32 (unencoded.code (i + 1), pos)
						pos := pos + Natural_32_bytes
					end
					i := i + 1
				end
				count := pos
			end
		end

	write_string_32 (str: READABLE_STRING_32)
		local
			i, pos, first_index, last_index: INTEGER; compressed_32: SPECIAL [NATURAL_8]
			area: SPECIAL [CHARACTER_32]; s: EL_STRING_32_ROUTINES
			is_native: BOOLEAN
		do
			if attached big_enough_buffer (size_of_string_32 (str)) as buf then
				pos := count; is_native := is_native_endian
				buf.put_integer_32 (str.count, pos)
				pos := pos + Integer_32_bytes

				if attached s.cursor (str) as cursor then
					area := cursor.area
					first_index := cursor.area_first_index
					last_index := cursor.area_last_index
				end
				from i := first_index until i > last_index loop
					compressed_32 := new_compressed_natural_32 (area [i].natural_32_code, is_native)
					buf.put_special_natural_8 (compressed_32, 0, pos, compressed_32.count)
					pos := pos + compressed_32.count
					i := i + 1
				end
				count := pos
			end
		end

	write_string_8 (str: READABLE_STRING_8)
			-- Write `str'.
		local
			i, pos, first_index, last_index: INTEGER
			area: SPECIAL [CHARACTER_8]; s: EL_STRING_8_ROUTINES
		do
			write_compressed_natural_32 (str.count.to_natural_32)
			if attached s.cursor (str) as cursor then
				area := cursor.area
				first_index := cursor.area_first_index
				last_index := cursor.area_last_index
			end
			if attached big_enough_buffer (str.count) as buf then
				pos := count
				from i := first_index until i > last_index loop
					buf.put_character (area [i], pos)
					pos := pos + 1
					i := i + 1
				end
				count := pos
			end
		end

end