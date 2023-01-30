note
	description: "[
		Decodes [https://en.wikipedia.org/wiki/Base64 base 64 encoded text] as type [$source SPECIAL [NATURAL_8]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-29 17:59:58 GMT (Sunday 29th January 2023)"
	revision: "12"

class
	EL_BASE_64_DECODER

inherit
	EL_BASE_64_ENCODE_DECODE

create
	make

feature -- Access

	data (base_64: STRING): SPECIAL [NATURAL_8]
		local
			i, i_final, skip_count: INTEGER; area: SPECIAL [CHARACTER]
		do
			create Result.make_empty ((base_64.count // 4 + 1) * 3)
			area := base_64.area; i_final := base_64.count
			from i := 0 until i = i_final loop
				if i + 4 >= i_final then
					-- no '=' padding at the end
					create area.make_filled ('=', 4)
					area.copy_data (base_64.area, i, 0, i_final - i)
					skip_count := append (area, 0, Result)

					i_final := i + 4 + skip_count -- exit loop
				else
					skip_count := append (area, i, Result)
				end
				i := i + 4 + skip_count
			end
		end

feature {NONE} -- Implementation

	append (area: SPECIAL [CHARACTER]; offset: INTEGER; output: SPECIAL [NATURAL_8]): INTEGER
		local
			i, code, skip_count, l_count: INTEGER; c: CHARACTER; invalid_padding, done: BOOLEAN
			area_4: like quartet
		do
			area_4 := quartet; area_4.wipe_out
			from i := 0 until area_4.count = 4 or else done loop
				c := area [offset + i + skip_count]
				if c = '=' then
					-- Note: RFC 2045 says "Because it is used only for padding
					-- at the end of the data, the occurrence of any '=' characters
					-- may be taken as evidence that the end of the data has
					-- been reached (without truncation in transit)."
					inspect i
						when 0, 1 then
							-- Invalid base64 stream: =*** OR *=**
							invalid_padding := True
					else
					end
					done := True
				else
					code := decoded (c)
					inspect code
						when Bad_character, White_space then
							skip_count := skip_count + 1
					else
						area_4.extend (code)
						i := i + 1
					end
				end
			end
			if not invalid_padding and then attached to_triplet (area_4) as area_3 then
				l_count := area_3.count
				from i := 0 until i = l_count loop
					output.extend (area_3 [i].to_natural_8)
					i := i + 1
				end
			end
			Result := skip_count
		end

	decoded (c: CHARACTER_32): INTEGER
			-- Decoded character;
			-- Returns -1 if `c' is an ignorable character.
			-- Returns -2 if `c' is an invalid character.
		do
			inspect c
				when ' ', '%T', '%R', '%N' then
					Result := White_space
				when '=' then
					Result := 0 -- treat padding character as 0 bits
				when 'A' .. 'Z' then
					Result := c.code - {ASCII}.Upper_a
				when 'a' .. 'z' then
					Result := 26 + c.code - {ASCII}.Lower_a
				when '0' .. '9' then
					Result := 52 + c.code - {ASCII}.zero
				when '+' then
					Result := 62
				when '/' then
					Result := 63
			else
				Result := Bad_character
			end
		ensure
			valid_decoded_character: Result >= Bad_character and Result < 64
		end

	to_triplet (area_4: like quartet): like triplet
		local
			bitmap, sextet_count, octet_count: INTEGER
		do
			Result := triplet; Result.wipe_out
			sextet_count := area_4.count; octet_count := sextet_count - 1
--			fill triplet in reverse from bitmap
			Result.fill_with (0, 0, octet_count - 1)

--			load sextets into bitmap and align as octets
			bitmap := new_area_bitmap (area_4, 6) |>> alignment_shift (sextet_count, octet_count)

--			write `bitmap' octets into `Result'
			fill_area (Result, octet_count, bitmap, 8, Octet_mask)
		end

feature {NONE} -- Constants

	White_space: INTEGER = -1

	Bad_character: INTEGER = -2

	Octet_mask: INTEGER = 0xFF

end