note
	description: "XML general string escaper"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-02 12:14:51 GMT (Saturday 2nd May 2020)"
	revision: "10"

deferred class
	EL_XML_GENERAL_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER
		rename
			make as make_escaper
		redefine
			append_escape_sequence, is_escaped
		end

	EL_SHARED_ONCE_ZSTRING

	EL_SHARED_ONCE_STRING_8

feature {NONE} -- Initialization

	make
		do
			make_escaper (Basic_entities)
		end

	make_128_plus
			-- include escaping of all codes > 128
		do
			make; escape_128_plus := True
		end

feature -- Transformation

	append_escape_sequence (str: like new_string; code: NATURAL)
		do
			str.append (escape_sequence (code))
		end

	escape_sequence (code: NATURAL): STRING
		local
			byte_count, i: INTEGER
			n, digit: NATURAL
		do
			Result := empty_once_string_8
			if escape_128_plus and then code > 128 then
				Result.append (once "&#x")

				byte_count := hex_byte_count (code)
				from i := 1 until i > byte_count loop
					Result.append_character ('0')
					i := i + 1
				end
				n := code
				from i := Result.count until i = Result.count - byte_count loop
					digit := (n & 0xF)
					Result [i] := digit.to_hex_character
					n := n |>> 4
					i := i - 1
				end
			else
				Result.append_character ('&')
				inspect code.to_character_8
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
			end
			Result.append_character (';')
		ensure
			valid_count: Result.count >= 4 and then (Result [1] = '&' and Result [Result.count] = ';')
		end

feature {NONE} -- Implementation

	hex_byte_count (code: NATURAL): INTEGER
		local
			mask: NATURAL
		do
			Result := 8
			mask := 0xF
			mask := mask |<< (32 - 4)
			from until mask = 0 or else (code & mask).to_boolean loop
				mask := mask |>> 4
				Result := Result - 1
			end
		end

	is_escaped (code: NATURAL): BOOLEAN
		do
			if escape_128_plus and then code > 128 then
				Result := True
			else
				Result := code_table.has_key (code)
			end
		end

	new_string (n: INTEGER): STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	escape_128_plus: BOOLEAN

feature {NONE} -- Constants

	Basic_entities: STRING = "<>&'%""

end
