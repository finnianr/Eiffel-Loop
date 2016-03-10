note
	description: "Summary description for {EL_UC_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:27 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_UC_ROUTINES

feature -- UTF-8 conversion

	encoded_byte_count (a_byte_code: NATURAL): INTEGER
			-- Number of bytes which were necessary to encode
			-- the unicode character whose first byte is `a_byte_code'
		require
			is_encoded_first_byte: is_encoded_first_byte (a_byte_code)
		do
			if a_byte_code <= 127 then
					-- 0xxxxxxx
				Result := 1

			elseif a_byte_code <= 223 then
					-- 110xxxxx
				Result := 2

			elseif a_byte_code <= 239 then
					-- 1110xxxx
				Result := 3

			else
					-- 11110xxx
				Result := 4
			end
		ensure
			encoded_byte_code_large_enough: Result >= 1
			encoded_byte_code_small_enough: Result <= 4
		end

	encoded_first_value (a_byte_code: NATURAL): NATURAL
			-- Value encoded in first byte
		require
			is_encoded_first_byte: is_encoded_first_byte (a_byte_code)
		do
			Result := a_byte_code
			if a_byte_code <= 127 then
					-- 0xxxxxxx

			elseif a_byte_code <= 223 then
					-- 110xxxxx
				Result := Result \\ 32

			elseif a_byte_code <= 239 then
					-- 1110xxxx
				Result := Result \\ 16

			elseif a_byte_code <= 244 then
					-- 11110xxx
				Result := Result \\ 8
			end
		ensure
			value_positive: Result >= 0
			value_small_enough: Result < 128
		end

	encoded_next_value (a_byte_code: NATURAL): NATURAL
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

feature -- Code test

	is_encoded_first_byte (a_byte_code: NATURAL): BOOLEAN
			-- Is `a_byte_code' the first byte in UTF-8 encoding?
		do
				-- All but 10xxxxxx and 1111111x
			Result := (a_byte_code <= 127 or (194 <= a_byte_code and a_byte_code <= 244))
		end

	is_encoded_next_byte (a_byte_code: NATURAL): BOOLEAN
			-- Is `a_byte_code' one of the next bytes in UTF-8 encoding?
		do
				-- 10xxxxxx
			Result := (127 < a_byte_code and a_byte_code <= 191)
		end

end
