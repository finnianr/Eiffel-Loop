note
	description: "[
		Encodes a byte array as [https://en.wikipedia.org/wiki/Base64 base 64 encoded] text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-29 17:55:40 GMT (Sunday 29th January 2023)"
	revision: "9"

class
	EL_BASE_64_ENCODER

inherit
	EL_BASE_64_ENCODE_DECODE
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create output_string.make_empty
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

	put_memory (bytes: MANAGED_POINTER; nb: INTEGER)
		require
			valid_size: nb <= bytes.count
		local
			i: INTEGER
		do
			start (nb)
			if attached output_string as str and then attached triplet as area_3 then
				from i := 0 until i = nb loop
					put_character (area_3, bytes.read_character (i), str)
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
			nb := array.count; start (nb)
			if attached output_string as str and then attached triplet as area_3 then
				from i := 0 until i = nb loop
					put_character (area_3, array [i].to_character_8, str)
					i := i + 1
				end
			end
			finalize
		end

	put_string (a_string: STRING)
			-- Write `a_string' to output_string stream.
		local
			i, nb: INTEGER
		do
			nb := a_string.count
			start (nb)
			if attached output_string as str and then attached triplet as area_3 then
				from i := 1 until i > nb loop
					put_character (area_3, a_string.item (i), str)
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

	encoded (code: INTEGER): CHARACTER
		require
			valid_range: 0 <= code and code <= 64
		do
			inspect code
				when 0 .. 25 then
					Result := 'A' + code
				when 26 .. 51 then
					Result := 'a' + (code - 26)
				when 52 .. 61 then
					Result := '0' + (code - 52)
				when 62 then
					Result := '+'
				when 63 then
					Result := '/'
				when 64 then
					Result := '='
			else
				check
					valid_range: False
				end
			end
		end

	extend_triplet (area_3: like triplet; c: CHARACTER; str: STRING)
			-- Write `c' to `area_3'.
		require
			not_full: area_3.count < 3
		do
			area_3.extend (c.code)
			if area_3.count = 3 then
				write_quartet (to_quartet (area_3), str)
				area_3.wipe_out
			end
		ensure
			not_full: area_3.count < 3
		end

	finalize
			-- Try to close output_string stream if it is closable. Set
			-- `is_open_write' to false if operation was successful.
		do
			if triplet.count /= 0 then
				-- Padding will take place.
				write_quartet (to_quartet (triplet), output_string)
				triplet.wipe_out
			end
		ensure
			triplet_empty: triplet.count = 0
		end

	put_character (area_3: like triplet; c: CHARACTER; str: STRING)
			-- Write `c' to output_string stream.
		local
			c1, c2: CHARACTER
		do
			c1 := c
			if is_normalizing then
				if is_pending_line_break then
					is_pending_line_break := False
					if c = '%N' then
						c1 := '%N'
					else
						c1 := '%N'; c2 := c
						if c = '%R' then
							is_pending_line_break := True
						end
					end
				elseif c = '%N' then
					c1 := '%R'; c2 := '%N'
				elseif c = '%R' then
					is_pending_line_break := True
				end
			end
			extend_triplet (area_3, c1, str)
			if c2 > '%U' then
				extend_triplet (area_3, c2, str)
			end
		end

	start (byte_count: INTEGER)
		do
			line_count := 0; is_pending_line_break := False
			output_string.wipe_out
			output_string.grow (byte_count // 3 * 4 + 4)
		end

	to_quartet (area_3: like triplet): like quartet
			-- fill a quartet (padded, if necessary)
			-- See: https://en.wikipedia.org/wiki/Base64
		require
			triplet_not_empty: area_3.count /= 0
		local
			bitmap, sextet_count, octet_count: INTEGER
		do
			Result := quartet
--			padd entire quartet
			Result.fill_with (Padding_code, 0, 3)
			octet_count := area_3.count; sextet_count := octet_count + 1

--			load triplet octets in bitmap aligned as sextets
			bitmap := new_area_bitmap (area_3, 8) |<< alignment_shift (sextet_count, octet_count)

--			write `bitmap' sextets into `Result'
			fill_area (Result, sextet_count, bitmap, 6, Sextet_mask)
		end

	write_quartet (area_4: like quartet; str: STRING)
		local
			i: INTEGER
		do
			from i := 0 until i = 4 loop
				str.extend (encoded (area_4 [i]))
				if is_line_breaking then
					line_count := line_count + 1
					if line_count = Full_line_count then
						line_count := 0
						str.extend ('%N')
					end
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	is_pending_line_break: BOOLEAN
			-- Has the CR of a CRLF pair been written out?

	line_count: INTEGER
			-- Number of characters output_string in current line

	output_string: STRING

feature {NONE} -- Constants

	Full_line_count: INTEGER = 76
			-- Maximum line length

	Sextet_mask: INTEGER = 0x3F

end