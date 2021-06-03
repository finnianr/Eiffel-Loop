note
	description: "[
		Decodes [https://en.wikipedia.org/wiki/Base64 base 64 encoded text] as type [$source SPECIAL [NATURAL_8]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-03 15:34:16 GMT (Thursday 3rd June 2021)"
	revision: "1"

class
	EL_BASE_64_DECODER

inherit
	EL_BASE_64_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			create code_buffer.make_empty (4)
		end

feature -- Access

	data (base_64: STRING): SPECIAL [NATURAL_8]
		require
			valid_count: base_64.count \\ 4 = 0
		local
			i, i_final: INTEGER; area: SPECIAL [CHARACTER]
		do
			create Result.make_empty (base_64.count // 4 * 3)
			area := base_64.area; i_final := base_64.count
			from i := 0 until i >= i_final loop
				append (area, i, Result)
				i := i + 4
			end
		end

feature {NONE} -- Implementation

	append (area: SPECIAL [CHARACTER]; offset: INTEGER; output: SPECIAL [NATURAL_8])
		local
			i, code: INTEGER; c: CHARACTER; invalid_base_64: BOOLEAN
			codes: like code_buffer
		do
			codes := code_buffer; codes.wipe_out
			from i := 0 until i > 3 loop
				c := area [offset + i]
				if c = '=' then
					-- Note: RFC 2045 says "Because it is used only for padding
					-- at the end of the data, the occurrence of any '=' characters
					-- may be taken as evidence that the end of the data has
					-- been reached (without truncation in transit)."
					inspect i
						when 0 then
							-- Invalid base64 stream: =***.
							invalid_base_64 := True
							i := 4 -- Jump out of the loop.
						when 1 then
							-- Invalid base64 stream: *=**
							invalid_base_64 := True
							i := 4 -- Jump out of the loop.
						when 2 then
							-- Valid base64 stream: **==
							i := 4 -- Jump out of the loop.
						when 3 then
							-- Valid base64 stream: ***=
							i := 4 -- Jump out of the loop.
					end
				else
					code := decoded (c)
					inspect code
						when -1 then
							-- White space, ignore.
						when -2 then
							-- Bad base64 stream.
					else
						codes.extend (code)
					end
			end
				i := i + 1
			end
			if not invalid_base_64 then
				-- Bit-shift `codes' into 3 characters.
				code := (codes [0] * shift_2_bits) + (codes [1] // shift_4_bits)
				output.extend (code.to_natural_8)
				if codes.count > 2 then
					code := (codes [1] * shift_4_bits) + (codes [2] // shift_2_bits)
					code := code \\ 256
					output.extend (code.to_natural_8)
					if codes.count > 3 then
						code := (codes [2] * shift_6_bits) + (codes [3])
						code := code \\ 256
						output.extend (code.to_natural_8)
					end
				end
			end
		end

	decoded (c: CHARACTER_32): INTEGER
			-- Decoded character;
			-- Returns -1 if `c' is an ignorable character.
			-- Returns -2 if `c' is an invalid character.
		do
			inspect c
				when ' ', '%T', '%R', '%N' then
					Result := -1
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
				Result := -2
			end
		ensure
			valid_decoded_character: Result >= -2 and Result < 64
		end

feature {NONE} -- Internal attributes

	code_buffer: SPECIAL [INTEGER]
end