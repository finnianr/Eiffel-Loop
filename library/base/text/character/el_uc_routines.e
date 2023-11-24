note
	description: "Unicode routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-24 17:58:54 GMT (Friday 24th November 2023)"
	revision: "9"

expanded class
	EL_UC_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

feature -- UTF-8 conversion

	frozen encoded_byte_count (a_byte_code: NATURAL): INTEGER
		-- Number of bytes which were necessary to encode
		-- the unicode character whose first byte is `a_byte_code'
		require
			is_encoded_first_byte: is_encoded_first_byte (a_byte_code)
		do
			inspect a_byte_code
				when 0 .. 127 then -- 0xxxxxxx
					Result := 1

				when 128 .. 223 then -- 110xxxxx
					Result := 2

				when 224 .. 239 then -- 1110xxxx
					Result := 3
			else
					-- 11110xxx
				Result := 4
			end
		ensure
			encoded_byte_code_large_enough: Result >= 1
			encoded_byte_code_small_enough: Result <= 4
		end

	frozen encoded_first_value (a_byte_code: NATURAL): NATURAL
		-- Value encoded in first byte
		require
			is_encoded_first_byte: is_encoded_first_byte (a_byte_code)
		do
			Result := a_byte_code
			inspect a_byte_code
				when 0 .. 127 then -- 0xxxxxxx
				-- do nothing

				when 128 .. 223 then -- 110xxxxx
					Result := Result \\ 32

				when 224 .. 239 then -- 1110xxxx
					Result := Result \\ 16

				when 240 .. 244 then -- 11110xxx
					Result := Result \\ 8
			else
				-- do nothing
			end
		ensure
			value_positive: Result >= 0
			value_small_enough: Result < 128
		end

	frozen encoded_next_value (a_byte_code: NATURAL): NATURAL
		-- Value encoded in one of the next bytes
		require
			is_encoded_next_byte: is_encoded_next_byte (a_byte_code)
		do
				-- 10xxxxxx
			Result := a_byte_code \\ 64
		ensure
			value_positive: Result >= 0
			value_small_enough: Result < 64
		end

	frozen utf_8_byte_count (unicode: NATURAL): INTEGER
		-- number of bytes required to represent `unicode'
		do
			inspect unicode
				when 0 .. 0x7F then -- 0xxxxxxx
					Result := 1

				when 0x80 .. 0x7FF then -- 110xxxxx 10xxxxxx
					Result := 2

				when 0x800 .. 0xFFFF then -- 1110xxxx 10xxxxxx 10xxxxxx
					Result := 3
			else
			-- unicode <= 1FFFFF - there are no higher code points
			-- 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
				Result := 4
			end
		end

feature -- Code test

	frozen is_encoded_first_byte (a_byte_code: NATURAL): BOOLEAN
		-- Is `a_byte_code' the first byte in UTF-8 encoding?
		do
			-- All but 10xxxxxx and 1111111x
			inspect a_byte_code
				when 0 .. 0x7F then
					Result := True

				when 0xC2 .. 0xF4 then
					Result := True
			else
			end
		end

	frozen is_encoded_next_byte (a_byte_code: NATURAL): BOOLEAN
		-- Is `a_byte_code' one of the next bytes in UTF-8 encoding?
		do
			inspect a_byte_code
				when 0x80 .. 0xBF then -- 10xxxxxx
					Result := True
			else
			end
		end

end