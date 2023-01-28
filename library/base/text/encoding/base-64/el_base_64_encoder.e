note
	description: "[
		Encodes a byte array as [https://en.wikipedia.org/wiki/Base64 base 64 encoded] text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-28 16:51:23 GMT (Saturday 28th January 2023)"
	revision: "6"

class
	EL_BASE_64_ENCODER

create
	make

feature {NONE} -- Initialization

	make
		do
			create triplet.make_empty (3)
			create quartet.make_filled (Padding_code, 4)
			create output_string.make_empty
		ensure
			triplet_capacity: triplet.capacity = 3
		end

feature -- Access

	output (keep_ref: BOOLEAN): STRING
		do
			Result := output_string
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Status report

	is_line_breaking: BOOLEAN
		-- Are line breaks to be written out after `Full_line_count' characters?

	is_normalizing: BOOLEAN
		-- Are line-breaks normalized to CRLF before encoding?

feature -- Output

	put_string (a_string: STRING)
			-- Write `a_string' to output_string stream.
		local
			i, nb: INTEGER
		do
			nb := a_string.count
			start (nb)
			if attached output_string as str then
				from i := 1 until i > nb loop
					put_character (a_string.item (i), str)
					i := i + 1
				end
			end
			finalize
		end

	put_memory (bytes: MANAGED_POINTER; nb: INTEGER)
		require
			valid_size: nb <= bytes.count
		local
			i: INTEGER
		do
			start (nb)
			if attached output_string as str then
				from i := 0 until i = nb loop
					put_character (bytes.read_character (i), str)
					i := i + 1
				end
			end
			finalize
		end

	put_natural_8_array (array: SPECIAL [NATURAL_8])
			-- Write `a_string' to output_string stream.
		local
			i, nb: INTEGER
		do
			nb := array.count
			start (nb)
			if attached output_string as str then
				from i := 0 until i = nb loop
					put_character (array [i].to_character_8, str)
					i := i + 1
				end
			end
			finalize
		end

feature -- Element change

	enable_line_breaks (yes: BOOLEAN)
		do
			is_line_breaking := yes
		end

	enable_normalizing (yes: BOOLEAN)
		do
			is_normalizing := yes
		end

feature {NONE} -- Implementation

	buffer_character (c: CHARACTER; str: STRING)
			-- Write `c' to `triplet'.
		require
			not_full: triplet.count < 3
		do
			triplet.extend (c)
			if triplet.count = 3 then
				write_quartet (str, triplet)
			end
		ensure
			not_full: triplet.count < 3
		end

	finalize
			-- Try to close output_string stream if it is closable. Set
			-- `is_open_write' to false if operation was successful.
		do
			if triplet.count /= 0 then
					-- Padding will take place.
				write_quartet (output_string, triplet)
			end
		end

	put_character (c: CHARACTER; str: STRING)
			-- Write `c' to output_string stream.
		do
			if is_normalizing then
				if is_pending_line_break then
					is_pending_line_break := False
					if c = '%N' then
						buffer_character ('%N', str)
					else
						buffer_character ('%N', str)
						buffer_character (c, str)
						if c = '%R' then
							is_pending_line_break := True
						end
					end
				elseif c = '%N' then
					buffer_character ('%R', str)
					buffer_character ('%N', str)
				elseif c = '%R' then
					buffer_character (c, str)
					is_pending_line_break := True
				else
					buffer_character (c, str)
				end
			else
				buffer_character (c, str)
			end
		end

	start (byte_count: INTEGER)
		do
			line_count := 0; is_pending_line_break := False
			output_string.wipe_out
			output_string.grow (byte_count // 3 * 4 + 4)
		end

	write_character (c: INTEGER; str: STRING)
			-- Write `c' to the output_string stream.
		require
			valid_range: 0 <= c and c <= 64
		do
			inspect c
				when 0 .. 25 then
					str.extend ('A' + c)
				when 26 .. 51 then
					str.extend ('a' + (c - 26))
				when 52 .. 61 then
					str.extend ('0' + (c - 52))

				when 62 then
					str.extend ('+')
				when 63 then
					str.extend ('/')
				when 64 then
					str.extend ('=')
			else
				check
					valid_range: False
				end
			end
			if is_line_breaking then
				line_count := line_count + 1
				if line_count = Full_line_count then
					line_count := 0
					str.extend ('%N')
				end
			end
		end

	write_quartet (str: STRING; area_3: like triplet)
			-- Write a quartet (padded, if necessary) to `str'
			-- See: https://en.wikipedia.org/wiki/Base64
		require
			triplet_not_empty: area_3.count /= 0
		local
			area_4: like quartet; i, bitmap, sextet_count, l_count: INTEGER
		do
			area_4 := quartet
			from i := 0 until i = 4 loop
				area_4 [i] := Padding_code
				i := i + 1
			end
--			Load triplet bytes in bitmap
			l_count := area_3.count
			from i := 0 until i = l_count loop
				bitmap := (bitmap |<< 8) | area_3 [i].code
				i := i + 1
			end
			sextet_count := area_3.count + 1
--			Align octets with sextets
			bitmap := bitmap |<< (sextet_count * 6 - l_count * 8)

--			write sextets into quartet in reverse order
			l_count := sextet_count - 1
			from i := l_count until i < 0 loop
				area_4 [i] := bitmap & Sextet_mask
				bitmap := bitmap |>> 6
				i := i - 1
			end
			from i := 0 until i = 4 loop
				write_character (area_4 [i], str)
				i := i + 1
			end
			area_3.wipe_out
		ensure
			triplet_empty: area_3.count = 0
		end

feature {NONE} -- Internal attributes

	is_pending_line_break: BOOLEAN
			-- Has the CR of a CRLF pair been written out?

	line_count: INTEGER
			-- Number of characters output_string in current line

	output_string: STRING

	triplet: SPECIAL [CHARACTER]
		-- 3 characters to be encoded

	quartet: SPECIAL [INTEGER]
		-- 4 characters to be written

feature {NONE} -- Constants

	Full_line_count: INTEGER = 76
			-- Maximum line length

	Padding_code: INTEGER = 64
			-- Pad character ('=')

	Sextet_mask: INTEGER = 0x3F

end