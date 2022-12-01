note
	description: "[
		Decodes [https://en.wikipedia.org/wiki/Base64 base 64 encoded text] as type [$source SPECIAL [NATURAL_8]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-01 10:06:56 GMT (Thursday 1st December 2022)"
	revision: "6"

class
	EL_BASE_64_DECODER

inherit
	ASCII
		export
			{NONE} all
		end

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
			i, i_final: INTEGER; area: SPECIAL [CHARACTER]
		do
			create Result.make_empty ((base_64.count // 4 + 1) * 3)
			area := base_64.area; i_final := base_64.count
			from i := 0 until i = i_final loop
				if i + 4 >= i_final then
					-- no '=' padding at the end
					create area.make_filled ('=', 4)
					area.copy_data (base_64.area, i, 0, i_final - i)
					append (area, 0, Result)

					i_final := i + 4 -- exit loop
				else
					append (area, i, Result)
				end
				i := i + 4
			end
		end

feature {NONE} -- Implementation

	append (area: SPECIAL [CHARACTER]; offset: INTEGER; output: SPECIAL [NATURAL_8])
		local
			i, code: INTEGER; c: CHARACTER; invalid_padding: BOOLEAN
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
						when 0, 1 then
							-- Invalid base64 stream: =*** OR *=**
							invalid_padding := True
					else
					end
					i := 4 -- exit loop
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
					Result := c.code - Upper_a
				when 'a' .. 'z' then
					Result := 26 + c.code - Lower_a
				when '0' .. '9' then
					Result := 52 + c.code - zero
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