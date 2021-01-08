note
	description: "Xml escape routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 15:59:48 GMT (Friday 8th January 2021)"
	revision: "3"

deferred class
	EL_XML_ESCAPE_ROUTINES

inherit
	EL_MODULE_BUFFER_8

	EL_MODULE_HEXADECIMAL

feature {NONE} -- Implementation

	hexadecimal_entity (code: NATURAL; keep_ref: BOOLEAN): STRING
		require
			valid_code: code > 128
		local
			digit_count, i: INTEGER
			n, digit: NATURAL
		do
			Result := buffer_8.empty
			Result.append (once "&#x")

			digit_count := Hexadecimal.natural_digit_count (code)
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
			valid_count: Result.count = Hexadecimal.natural_digit_count (code) + 4
			valid_leading_trailing: Result [1] = '&' and Result [Result.count] = ';'
		end

	entity (c: CHARACTER; keep_ref: BOOLEAN): STRING
		-- standard character entity
		do
			Result := buffer_8.empty
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

end