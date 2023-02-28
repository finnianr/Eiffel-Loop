note
	description: "String experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-28 12:54:29 GMT (Tuesday 28th February 2023)"
	revision: "30"

class
	STRING_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_CONSOLE; EL_MODULE_EIFFEL

	EL_MODULE_USER_INPUT

	EL_SHARED_ENCODINGS

	EL_SHARED_ZCODEC_FACTORY

	EL_ENCODING_CONSTANTS

	STRING_HANDLER undefine default_create end

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("character_8_as_lower", agent test_character_8_as_lower)
			eval.call ("expanded_string", agent test_expanded_string)
			eval.call ("is_substitute_white", agent test_is_substitute_white)
		end

feature -- Tests

	test_character_8_as_lower
		-- STRING_TEST_SET.test_character_8_as_lower
		local
			i: INTEGER; c: CHARACTER; c32: EL_CHARACTER_32_ROUTINES
			uc: CHARACTER_32
		do
			from i := 1 until i > 0xFF loop
				c := i.to_character_8
				if c.is_alpha and c.is_upper then
					uc := c
					assert ("as_lower OK", c.as_lower = c32.to_lower (uc).to_character_8)
				end
				i := i + 1
			end
		end

	test_expanded_string
		-- STRING_TEST_SET.test_expanded_string
		local
			ex: EXPANDED_STRING; s: STRING
		do
			s := "abc"
			ex.share (s)
			assert ("same hash_code", ex.hash_code = 6382179)
		end

	test_is_substitute_white
		-- STRING_TEST_SET.test_is_substitute_white
		local
			c: CHARACTER
		do
			c := (26).to_character_8
			assert ("no space", not c.is_space)
		end

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
			create parts.make_adjusted_split (s, ',', {EL_STRING_ADJUST}.Left)
			across parts as part loop
				lio.put_string_field (part.cursor_index.out, part.item)
				lio.put_new_line
			end
		end

	check_if_euro_is_space
		local
			euro: CHARACTER_32
		do
			euro := '€'
			lio.put_labeled_string ("euro.is_space", euro.is_space.out)
			lio.put_new_line
			lio.put_labeled_string ("euro.is_space", C_properties.is_space (euro).out)
			lio.put_new_line
 		end

	check_if_type_name_unique
		local
			name_1, name_2: STRING
			type_id: INTEGER
		do
			type_id := ({like Current}).type_id
			name_1 := Eiffel.type_name_of_type (type_id)
			name_2 := Eiffel.type_name_of_type (type_id)
			if name_1 = name_2 then
				lio.put_line ("Unique")
			else
				lio.put_line ("Not unique")
			end
		end

	encode_string_for_console
		do
			across <<
				Encodings.System, Encodings.Console, Encodings.Utf_8, Encodings.Latin_1
			>> as encoding loop
				lio.put_line (encoding.item.code_page)
			end
			io.put_string (Console.encoded ({STRING_32} "Dún Búinne"))
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

	find_highest_common_character
		-- Find highest character in commone with all Latin and Windows ZSTRING codecs
		-- The answer is 127
		local
			i: INTEGER; c: CHARACTER; uc: CHARACTER_32
			done: BOOLEAN
		do
			from i := 1 until done or else i > 255 loop
				c := i.to_character_8; uc := i.to_character_32
				if same_for_all_codecs (c, uc) then
					lio.put_integer_field ("Same for all codecs", i)
				else
					lio.put_integer_field ("NOT the same", i)
					done := True
				end
				lio.put_new_line
				i := i + 1
			end
		end

	fuzzy_match
		local
			a: STRING
		do
			a := "image/jpeg"
			across << "jpg", "jpeg", "png" >> as ext loop
				lio.put_labeled_string ("Matched " + ext.item, a.fuzzy_index (ext.item, 1, 1).to_boolean.out )
				lio.put_new_line
			end
--			Matched jpg: True
--			Matched jpeg: True
--			Matched png: True
		end

	hexadecimal_to_natural_64
		local
			hex: EL_HEXADECIMAL_CONVERTER
		do
			lio.put_string (hex.to_natural_64 ("0x00000A987").out)
			lio.put_new_line
		end

	index_of_empty
		local
			line: ZSTRING
		do
			create line.make_empty
			assert ("is 0", line.index_of (' ', 1) = 0)
		end

	input_capital_a_umlaut
		local
			line: ZSTRING
		do
			line := User_input.line ("Enter a Ä character (ALT 0196)")
			lio.put_new_line
			assert ("is Ä", line [1] = 'Ä')
		end

	input_unicode_character
		local
			str: ZSTRING; euro: ZSTRING
		do
			lio.put_line ("Enter a EURO symbol")
			io.read_line
			lio.put_new_line
			create str.make_from_utf_8 (io.last_string)
			lio.put_labeled_string ("Euro", str)
			lio.put_new_line
			create euro.make_filled ((0x20AC).to_character_32, 1)
			assert ("Console.encoded (euro) ~ io.last_string", Console.encoded (euro) ~ io.last_string)
			assert ("Console.decoded (io.last_string) ~ euro", Console.decoded (io.last_string) ~ euro)
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

	right_adjust
		do
			if attached ("abc%R") as str then
				str.right_adjust
				lio.put_integer_field ("str.count", str.count)
				lio.put_new_line
			end
		end

	split_empty_count
		do
			lio.put_integer_field ("count", ("").split (',').count)
			lio.put_new_line
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

	substring_beyond_bounds
		local
			name: STRING
		do
			name := "Muller"
			lio.put_string_field ("name", name.substring (1, name.count + 1))
			lio.put_new_line
		end

	test_has_repeated_hexadecimal_digit
		do
			lio.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAAA)); lio.put_new_line
			lio.put_boolean (has_repeated_hexadecimal_digit (0x1AAAAAAAAAAAAAAA)); lio.put_new_line
			lio.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAA1)); lio.put_new_line
		end

	url_string
		local
			str: EL_URI_PATH_ELEMENT_STRING_8
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

	same_for_all_codecs (c: CHARACTER; uc: CHARACTER_32): BOOLEAN
		local
			lower, upper, i: NATURAL; codec: EL_ZCODEC
		do
			Result := True
			across << 1 |..| 11, 13 |..| 14, 1250 |..| 1258 >> as interval until not Result loop
				lower := interval.item.lower.to_natural_32
				upper := interval.item.upper.to_natural_32
				from i := lower until not Result or else i > upper loop
					if i > 1000 then
						codec := Codec_factory.codec_by (Windows | i)
					else
						codec := Codec_factory.codec_by (Latin | i)
					end
					if codec.unicode_table [c.code] /= uc then
						Result := False
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Constants

	C_properties: CHARACTER_PROPERTY
			-- Property for Unicode characters.
		once
			create Result.make
		end

	Mime_type_template, Text_charset_template: ZSTRING
		once
			Result := "text/%S; charset=%S"
		end

end