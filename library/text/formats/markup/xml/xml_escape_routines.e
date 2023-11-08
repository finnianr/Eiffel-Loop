note
	description: "Xml escape routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 17:12:07 GMT (Wednesday 8th November 2023)"
	revision: "9"

deferred class
	XML_ESCAPE_ROUTINES

inherit
	EL_SHARED_STRING_8_BUFFER_SCOPES

feature {NONE} -- Implementation

	entity (c: CHARACTER; keep_ref: BOOLEAN): STRING
		-- standard character entity
		do
			Result := Entity_buffer.empty
			Result.append_character ('&')
			inspect c
				when '<' then
					Result.append (once "lt")
				when '>' then
					Result.append (once "gt")
				when '&' then
					Result.append (once "amp")
				when '%'' then
					Result.append (once "apos")
				when '"' then
					Result.append (once "quot")
			else
			end
			Result.append_character (';')
			if keep_ref then
				Result := Result.twin
			end
		ensure
			valid_count: Result.count >= 4
			valid_leading_trailing: Result [1] = '&' and Result [Result.count] = ';'
		end

	hexadecimal_digit_count (code: NATURAL): INTEGER
		local
			hex: EL_HEXADECIMAL_CONVERTER
		do
			Result := hex.natural_digit_count (code)
		end

	hexadecimal_entity (code: NATURAL; keep_ref: BOOLEAN): STRING
		require
			valid_code: code > 128
		local
			digit_count, i: INTEGER; n, digit: NATURAL
			hex: EL_HEXADECIMAL_CONVERTER
		do
			Result := Entity_buffer.empty
			Result.append (once "&#x")

			digit_count := hex.natural_digit_count (code)
			from i := 1 until i > digit_count loop
				Result.append_character ('0')
				i := i + 1
			end
			n := code
			from i := Result.count until i = Result.count - digit_count loop
				digit := (n & 0xF)
				Result [i] := digit.to_hex_character
				n := n |>> 4
				i := i - 1
			end
			Result.append_character (';')
			if keep_ref then
				Result := Result.twin
			end
		ensure
			valid_count: Result.count = hexadecimal_digit_count (code) + 4
			valid_leading_trailing: Result [1] = '&' and Result [Result.count] = ';'
		end

feature {NONE} -- Constants

	Entity_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end