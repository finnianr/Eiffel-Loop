note
	description: "[
		Encodes a byte array as [https://en.wikipedia.org/wiki/Base64 base 64 encoded] text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-03 15:27:01 GMT (Thursday 3rd June 2021)"
	revision: "1"

class
	EL_BASE_64_ENCODER

inherit
	EL_BASE_64_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			create triplet.make_empty (3)
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
			-- Are line breaks to be written out after 76 characters?

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
				write_quartet (str)
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
				write_quartet (output_string)
			end
		end

	put_character (c: CHARACTER; str: STRING)
			-- Write `c' to output_string stream.
		do
			if not is_normalizing then
				buffer_character (c, str)
			else
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
			end
		end

	start (byte_count: INTEGER)
		do
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
				if line_count = full_line_count then
					line_count := 0
					str.extend ('%N')
				end
			end
		end

	write_quartet (str: STRING)
			-- Write a quartet (padded, if necessary) to `str'.
		require
			triplet_not_empty: triplet.count /= 0
		local
			a_code, another_code, a_remainder: INTEGER
		do
			a_code := triplet [0].code
			a_remainder := a_code \\ shift_2_bits
			another_code := a_code // shift_2_bits
			write_character (another_code, str)
			another_code := a_remainder * shift_4_bits
			if triplet.count = 1 then
				write_character (another_code, str)
				write_character (padding, str)
				write_character (padding, str)
			else
				a_code := triplet [1].code
				a_remainder := a_code \\ shift_4_bits
				another_code := another_code + a_code // shift_4_bits
				write_character (another_code, str)
				another_code := a_remainder * shift_2_bits
				if triplet.count = 2 then
					write_character (another_code, str)
					write_character (padding, str)
				else
					a_code := triplet [2].code
					a_remainder := a_code \\ shift_6_bits
					another_code := another_code + a_code // shift_6_bits
					write_character (another_code, str)
					another_code := a_remainder
					write_character (another_code, str)
				end
			end
			triplet.wipe_out
		ensure
			triplet_empty: triplet.count = 0
		end

feature {NONE} -- Internal attributes

	is_pending_line_break: BOOLEAN
			-- Has the CR of a CRLF pair been written out?

	line_count: INTEGER
			-- Number of characters output_string in current line

	output_string: STRING

	triplet: SPECIAL [CHARACTER]
		-- Three characters to be encoded

feature {NONE} -- Constants

	full_line_count: INTEGER = 76
			-- Maximum line length

	padding: INTEGER = 64
			-- Pad character ('=')

end