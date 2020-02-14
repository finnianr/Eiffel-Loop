note
	description: "String experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-13 21:21:11 GMT (Thursday 13th February 2020)"
	revision: "3"

class
	STRING_EXPERIMENTS

inherit
	EXPERIMENTAL

	SYSTEM_ENCODINGS
		rename
			Utf32 as Unicode,
			Utf8 as Utf_8
		export
			{NONE} all
		end

	EL_MODULE_HEXADECIMAL

feature -- Basic operations

	alternative_once_naming
		do
			lio.put_line (Mime_type_template)
			lio.put_line (Text_charset_template)
		end

	audio_info_parsing
		local
			s: ZSTRING; parts: EL_ZSTRING_LIST
		do
			s := "Stream #0.0(und): Audio: aac, 44100 Hz, stereo, fltp, 253 kb/s"
			create parts.make_with_separator (s, ',', True)
			across parts as part loop
				lio.put_string_field (part.cursor_index.out, part.item)
				lio.put_new_line
			end
		end

	encode_string_for_console
		local
			str: STRING_32; str_2: STRING
		do
			across << System_encoding, Console_encoding, Utf_8, Iso_8859_1 >> as encoding loop
				lio.put_line (encoding.item.code_page)
			end
			str := {STRING_32} "Dún Búinne"
			Unicode.convert_to (Console_encoding, str)
			if Unicode.last_conversion_successful then
				str_2 := Unicode.last_converted_string_8
				io.put_string (str_2)
			end
		end

	escaping_text
		do
			lio.put_string_field ("&aa&bb&", escaped_text ("&aa&bb&").as_string_8)
		end

	find_console_encoding
		local
			system: SYSTEM_ENCODINGS; message: STRING_32
		do
			create system
			lio.put_string (system.console_encoding.code_page)
			lio.put_new_line
			message := "Euro sign: "
			message.append_code (0x20AC)
			lio.put_line (message)
		end

	hexadecimal_to_natural_64
		do
			lio.put_string (Hexadecimal.to_natural_64 ("0x00000A987").out)
			lio.put_new_line
		end

	reading_character_32_as_natural_8
		local
			chars: SPECIAL [CHARACTER_32]; ptr: MANAGED_POINTER
			i: INTEGER
		do
			create chars.make_filled (' ', 2)
			create ptr.share_from_pointer (chars.base_address, chars.count * 4)
			from i := 0 until i = ptr.count loop
				ptr.put_natural_8 (i.to_natural_8, i)
				i := i + 1
			end
			from i := 0 until i = ptr.count loop
				lio.put_integer_field (i.out, ptr.read_natural_8 (i))
				lio.put_new_line
				i := i + 1
			end
		end

	replace_delimited_substring_general
		local
			email: ZSTRING
		do
			across << "freilly8@gmail.com", "finnian@gmail.com", "finnian-buyer@eiffel-loop.com" >> as address loop
				email := address.item
				lio.put_string (email)
				email.replace_delimited_substring_general ("finnian", "@eiffel", "", False, 1)
				lio.put_string (" -> "); lio.put_string (email)
				lio.put_new_line
			end
		end

	string_to_integer_conversion
		local
			str: ZSTRING
		do
			str := ""
			lio.put_string ("str.is_integer: ")
			lio.put_boolean (str.is_integer)
		end

	substitute_template_with_string_8
		local
			type: STRING
		do
			type := "html"
			lio.put_string_field ("Content", Mime_type_template #$ [type, "UTF-8"])
			lio.put_new_line
			lio.put_string_field ("Content", Mime_type_template #$ [type, "UTF-8"])
		end

	substitution
		local
			template: EL_STRING_8_TEMPLATE
		do
			create template.make ("from $var := 1 until $var > 10 loop")
			template.set_variable ("var", "i")
			lio.put_line (template.substituted)
		end

	substitution_template
			--
		local
			l_template: EL_STRING_8_TEMPLATE
		do
			create l_template.make ("x=$x, y=$y")
			l_template.set_variable ("x", "100")
			l_template.set_variable ("y", "200")
			lio.put_line (l_template.substituted)
		end

	test_has_repeated_hexadecimal_digit
		do
			lio.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAAA)); lio.put_new_line
			lio.put_boolean (has_repeated_hexadecimal_digit (0x1AAAAAAAAAAAAAAA)); lio.put_new_line
			lio.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAA1)); lio.put_new_line
		end

	url_string
		local
			str: EL_URL_STRING_8
		do
			create str.make_empty
			str.append_general ("freilly8@gmail.com")
		end

feature {NONE} -- Implementation

	escaped_text (s: READABLE_STRING_GENERAL): READABLE_STRING_GENERAL
			-- `text' with doubled ampersands.
		local
			n, l_count: INTEGER; l_amp_code: NATURAL_32; l_string_32: STRING_32
		do
			l_amp_code := ('&').code.as_natural_32
			l_count := s.count
			n := s.index_of_code (l_amp_code, 1)

			if n > 0 then
					-- There is an ampersand present in `s'.
					-- Replace all occurrences of "&" with "&&".
					--| Cannot be replaced with `{STRING_32}.replace_substring_all' because
					--| we only want it to happen once, not forever.
				from
					create l_string_32.make (l_count + 1)
					l_string_32.append_string_general (s)
				until
					n > l_count
				loop
					n := l_string_32.index_of_code (l_amp_code, n)
					if n > 0 then
						l_string_32.insert_character ('&', n)
							-- Increase count local by one as a character has been inserted.
						l_count := l_count + 1
						n := n + 2
					else
						n := l_count + 1
					end
				end
				Result := l_string_32
			else
				Result := s
			end
		ensure
			ampersand_occurrences_doubled: Result.as_string_32.occurrences ('&') =
				(old s.twin.as_string_32).occurrences ('&') * 2
		end

	has_repeated_hexadecimal_digit (n: NATURAL_64): BOOLEAN
		local
			first, hex_digit: NATURAL_64
			i: INTEGER
		do
			first := n & 0xF
			hex_digit := first
			from i := 1 until hex_digit /= first or i > 15 loop
				hex_digit := n.bit_shift_right (i * 4) & 0xF
				i := i + 1
			end
			Result := i = 16 and then hex_digit = first
		end

feature {NONE} -- Constants

	Mime_type_template, Text_charset_template: ZSTRING
		once
			Result := "text/%S; charset=%S"
		end

end
