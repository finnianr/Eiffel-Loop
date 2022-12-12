note
	description: "[
		Decodes [https://en.wikipedia.org/wiki/Base64 base 64 encoded text] as type [$source SPECIAL [NATURAL_8]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 9:01:28 GMT (Monday 12th December 2022)"
	revision: "7"

class
	EL_BASE_64_DECODER

create
	make

feature {NONE} -- Initialization

	make
		do
			create code_buffer.make_empty (4)
		end

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

					i_final := i + 4 -- exit loop
				else
					skip_count := append (area, i, Result)
				end
				i := i + 4 + skip_count
			end
		end

feature {NONE} -- Implementation

	append (area: SPECIAL [CHARACTER]; offset: INTEGER; output: SPECIAL [NATURAL_8]): INTEGER
		local
			i, code, skip_count: INTEGER; c: CHARACTER; invalid_padding, done: BOOLEAN
			codes: like code_buffer
		do
			codes := code_buffer; codes.wipe_out
			from i := 0 until codes.count = 4 or else done loop
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
						codes.extend (code)
						i := i + 1
					end
				end
			end
			if not invalid_padding then
				-- Bit-shift `codes' into 3 characters.
				code := (codes [0] |<< 2) + (codes [1] |>> 4)
				output.extend (code.to_natural_8)
				if codes.count > 2 then
					code := (codes [1] |<< 4) + (codes [2] |>> 2)
					code := code \\ 256
					output.extend (code.to_natural_8)
					if codes.count > 3 then
						code := (codes [2] |<< 6) + (codes [3])
						code := code \\ 256
						output.extend (code.to_natural_8)
					end
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

feature {NONE} -- Internal attributes

	code_buffer: SPECIAL [INTEGER]

feature {NONE} -- Constants

	White_space: INTEGER = -1

	Bad_character: INTEGER = -2

end