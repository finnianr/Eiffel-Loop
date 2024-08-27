note
	description: "Test classes ${EL_APPENDABLE_ZSTRING} and ${EL_PREPENDABLE_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 7:55:52 GMT (Tuesday 27th August 2024)"
	revision: "5"

class
	ZSTRING_CONCATENATION_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_CHARACTER_32_CONSTANTS

	EL_SHARED_ENCODINGS; EL_SHARED_TEST_TEXT

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["append",						  agent test_append],
				["append_encoded",			  agent test_append_encoded],
				["append_replaced",			  agent test_append_replaced],
				["append_string_general",	  agent test_append_string_general],
				["append_substring_general", agent test_append_substring_general],
				["append_to_string_32",		  agent test_append_to_string_32],
				["append_unicode",			  agent test_append_unicode],
				["append_utf_8",				  agent test_append_utf_8],
				["prepend",						  agent test_prepend],
				["prepend_string_general",	  agent test_prepend_string_general],
				["prepend_substring",		  agent test_prepend_substring]
			>>)
		end

feature -- Appending tests

	test_append
		do
			test_concatenation ({STRING_TEST_IMPLEMENTATION}.Append)
		end

	test_append_encoded
		-- ZSTRING_CONCATENATION_TEST_SET.test_append_encoded
		local
			test: STRING_TEST; encoded: STRING; encoding_id: NATURAL
			encodeable: EL_ENCODEABLE_AS_TEXT; uncovertable_count: INTEGER
			unicode: ENCODING
		do
			create encodeable.make_default
			create test
			unicode := Encodings.Unicode
		 	across Text.lines as line loop
		 		test.set (line.item)
				across Text.all_encodings as encoding loop
					encoding_id := encoding.item
					test.zs.wipe_out
					encodeable.set_encoding (encoding_id)
					unicode.convert_to (encodeable.as_encoding, test.s_32)
					if unicode.last_conversion_lost_data then
						uncovertable_count := uncovertable_count + 1
					else
						encoded := unicode.last_converted_string_8
						test.zs.append_encoded (unicode.last_converted_string_8, encoding_id)
						assert ("same string", test.is_same)
					end
				end
		 	end
		 	assert ("82 not convertable", uncovertable_count = 82)

		 	across Text.lines as line loop
		 		if line.item.is_valid_as_string_8 then
			 		test.set (line.item)
			 		test.zs.wipe_out
			 		test.zs.append_encoded (test.s_32.to_string_8, {EL_ENCODING_TYPE}.Latin_1)
			 		assert ("same strings", test.is_same)
		 		end
		 	end
		end

	test_append_replaced
		note
			testing: "covers/{EL_APPENDABLE_ZSTRING}.append_replaced"
		local
			zstr, line, entity: ZSTRING; str_32, line_32, entity_32: STRING_32
			s: EL_STRING_32_ROUTINES
		do
			entity_32 := "&nbsp;"; entity := entity_32
			create str_32.make_empty
			create zstr.make_empty
			across 1 |..| 2 as n loop
				str_32.wipe_out; zstr.wipe_out
				across Text.lines as list until list.cursor_index > 3 loop
					if n.item = 2 then
						line_32 := s.enclosed (list.item, ' ', ' ')
					else
						line_32 := list.item
					end
					line := line_32; str_32.append (line_32)
					zstr.append_replaced (line, space, entity)
				end
				str_32.replace_substring_all (space.as_string_32 (1), entity_32)
				assert_same_string (Void, str_32, zstr)
			end
		end

	test_append_string_general
		-- ZSTRING_CONCATENATION_TEST_SET.test_append_string_general
		note
			testing: "[
				covers/{ZSTRING}.append_string_general,
				covers/{ZSTRING}.substring
			]"
		local
			test: STRING_TEST; substring_size, start_index, end_index: INTEGER
		do
			across << False, True >> as boolean loop
				if boolean.item then
					create test
				else
					create {IMMUTABLE_STRING_TEST} test
				end

				across << 3, 5, 7 >> as n loop
					substring_size := n.item
					across Text.lines as line loop
						test.set (line.item)
						test.zs.wipe_out
						end_index := 0
						from start_index := 1 until end_index = test.s_32.count loop
							end_index := (start_index + substring_size - 1).min (test.s_32.count)
							test.set_substrings (start_index, end_index)
							assert ("append_string_general OK", test.append_string_general)
							start_index := start_index + substring_size
						end
						assert ("same size strings", test.is_same_size)
					end
				end
			end
		end

	test_append_substring_general
		note
			testing: "[
				covers/{EL_APPENDABLE_ZSTRING}.append_substring_general,
				covers/{EL_APPENDABLE_ZSTRING}.substring
			]"
		local
			test: STRING_TEST; substring_size, start_index, end_index: INTEGER
		do
			across << False, True >> as boolean loop
				if boolean.item then
					create test
				else
					create {IMMUTABLE_STRING_TEST} test
				end

				across << 3, 5, 7 >> as n loop
					substring_size := n.item
					across Text.lines as line loop
						test.set (line.item)
						test.zs.wipe_out
						end_index := 0
						from start_index := 1 until end_index = test.s_32.count loop
							end_index := (start_index + substring_size - 1).min (test.s_32.count)
							assert ("append_substring_general OK", test.append_substring_general (start_index, end_index))
							start_index := start_index + substring_size
						end
						assert ("same size strings", test.is_same_size)
					end
				end
			end
		end

	test_append_to_string_32
		-- ZSTRING_CONCATENATION_TEST_SET.test_append_to_string_32
		note
			testing: "[
				covers/{EL_APPENDABLE_ZSTRING}.append_to_string_8,
				covers/{EL_APPENDABLE_ZSTRING}.append_to_string_32
			]"
		local
			str_32, word_32: STRING_32; word: ZSTRING
			str_32_str_8, zstr_str_8: STRING_8
		do
			across Text.lines as line_32 loop
				create str_32.make (0)
				create str_32_str_8.make (0)
				create zstr_str_8.make (0)

				across line_32.item.split (' ') as list loop
					word_32 := list.item
					word := word_32
					if list.cursor_index > 1 then
						str_32.append_character (' ')
						str_32_str_8.append_character (' ')
						zstr_str_8.append_character (' ')
					end
					word.append_to_string_32 (str_32)
					if word_32.is_valid_as_string_8 then
						str_32_str_8.append_string_general (word_32)
						word.append_to_string_8 (zstr_str_8)
					end
				end
				assert ("same string", str_32 ~ line_32.item)
				assert ("same appended STRING_8", str_32_str_8 ~ zstr_str_8)
			end
		end

	test_append_unicode
		local
			a: ZSTRING
		do
			create a.make_empty
			across Text.russian_and_english as uc loop
				a.append_unicode (uc.item.natural_32_code)
			end
			assert_same_string ("append_unicode OK", a, Text.russian_and_english)
		end

	test_append_utf_8
		-- ZSTRING_CONCATENATION_TEST_SET.test_append_utf_8
		local
			utf_8: STRING; conv: EL_UTF_CONVERTER; test: STRING_TEST
		do
			create test
			across Text.lines as line loop
				test.wipe_out
				across conv.string_32_to_utf_8_string_8 (line.item).split (' ') as utf_word loop
					if test.s_32.count > 0 then
						test.append_character (' ')
					end
					test.zs.append_utf_8 (utf_word.item)
					test.s_32.append (conv.utf_8_string_8_to_string_32 (utf_word.item))
					assert ("same string", test.is_same)
				end
			end
		end

feature -- Prepending tests

	test_prepend
		do
			test_concatenation ({STRING_TEST_IMPLEMENTATION}.Prepend)
		end

	test_prepend_string_general
		-- ZSTRING_CONCATENATION_TEST_SET.test_prepend_string_general
		note
			testing: "[
				covers/{EL_PREPENDABLE_ZSTRING}.prepend_string_general,
				covers/{EL_READABLE_ZSTRING}.substring
			]"
		local
			test: STRING_TEST; substring_size, start_index, end_index: INTEGER
		do
			across << False, True >> as boolean loop
				if boolean.item then
					create test
				else
					create {IMMUTABLE_STRING_TEST} test
				end

				across << 3, 5, 7 >> as n loop
					substring_size := n.item
					across Text.lines as line loop
						test.set (line.item)
						test.zs.wipe_out
						start_index := test.s_32.count
						from end_index := test.s_32.count until start_index = 1 loop
							start_index := (end_index - substring_size + 1).max (1)
							test.set_substrings (start_index, end_index)
							assert ("prepend_string_general OK", test.prepend_string_general)
							end_index := end_index - substring_size
						end
						assert ("same size strings", test.is_same_size)
					end
				end
			end
		end

	test_prepend_substring
		local
			test: STRING_TEST; line: ZSTRING
			word_list: EL_OCCURRENCE_INTERVALS
			start_index, end_index: INTEGER; s: EL_STRING_32_ROUTINES
		do
			across Text.lines as line_32 loop
				line := line_32.item
				create test
				create word_list.make (line_32.item, ' ')
				start_index := 1
				from word_list.start until word_list.after loop
					end_index := word_list.item_lower - 1
					test.s_32.prepend_substring (line_32.item, start_index, end_index)
					test.s_32.prepend_substring (line_32.item, word_list.item_lower, word_list.item_upper)
					test.zs.prepend_substring (line, start_index, end_index)
					test.zs.prepend_substring (line, word_list.item_lower, word_list.item_upper)
					assert ("same string", test.is_same)
					start_index := word_list.item_upper + 1
					word_list.forth
				end
			end
		end

feature {NONE} -- Implementation

	test_concatenation (type: INTEGER)
		local
			test, substring_text: STRING_TEST; i, count: INTEGER
		do
			create test
			count := (Text.russian_and_english.count // 5) * 5
			from i := 1 until i > count loop
				substring_text := Text.russian_and_english.substring (i, i + 4)
				test.extend_strings (type, substring_text)

				assert (test.append_type_name (type) + " OK", test.is_same)
				i := i + 5
			end
		end

end