note
	description: "Testing class ${EL_CONVERTABLE_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-04 8:53:26 GMT (Friday 4th April 2025)"
	revision: "7"

class
	ZSTRING_CONVERTABLE_TEST_SET

inherit
	ZSTRING_EQA_TEST_SET

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["split",		  agent test_split],
				["to_latin_1",	  agent test_to_latin_1],
				["to_string_32", agent test_to_string_32],
				["to_utf_8",	  agent test_to_utf_8]
			>>)
		end

feature -- Tests

	test_split
		note
			testing: "[
				covers/{EL_READABLE_ZSTRING}.substring,
				covers/{EL_CONVERTABLE_ZSTRING}.split,
				covers/{EL_SEARCHABLE_ZSTRING}.index_of
			]"
		local
			split_list: LIST [ZSTRING]; split_list_32: LIST [STRING_32]
			test: STRING_TEST; i: INTEGER
		do
			create test.make_empty (Current)
			across Text.lines_32 as line loop
				test.set (line)
				from i := 1 until i > 3 loop
					split_list := test.zs.split_list (test.s_32 [i])
					split_list_32 := test.s_32.split (test.s_32 [i])
					assert ("same count", split_list.count = split_list_32.count)
					if split_list.count = split_list_32.count then
						if across split_list as str all str.same_string (split_list_32.i_th (@ str.cursor_index)) end then
							do_nothing
						else
							failed ("same content")
						end
					end
					i := i + 1
				end
			end
		end

	test_to_latin_1
		-- ZSTRING_CONVERTABLE_TEST_SET.test_to_latin_1
		note
			testing:	"[
				covers/{EL_CONVERTABLE_ZSTRING}.to_latin_1,
				covers/{EL_CONVERTABLE_ZSTRING}.to_string_8
			]"
		local
			str: ZSTRING
		do
			across Text.lines_32 as str_32 loop
				if str_32.is_valid_as_string_8 then
					str := str_32
					assert ("same string", str.to_latin_1 ~ str_32.to_string_8)
				end
			end
		end

	test_to_string_32
		-- ZSTRING_CONVERTABLE_TEST_SET.test_to_string_32
		note
			testing:	"[
				covers/{EL_CONVERTABLE_ZSTRING}.to_string_32,
				covers/{EL_READABLE_ZSTRING}.make_from_general,
				covers/{EL_COMPARABLE_ZSTRING}.same_characters_general
			]"
		local
			test: STRING_TEST
		do
			create test.make_empty (Current)
			across Text.lines_32 as line loop
				test.set (line)
				assert ("strings the same", test.is_same)
				assert ("to_string_32 is_equal", test.zs.to_string_32 ~ line)
			end
		end

	test_to_utf_8
		-- ZSTRING_CONVERTABLE_TEST_SET.test_to_utf_8
		note
			testing:	"[
				covers/{EL_CONVERTABLE_ZSTRING}.to_utf_8,
				covers/{EL_ZSTRING_IMPLEMENTATION}.leading_ascii_count,
				covers/{EL_WRITEABLE_ZSTRING}.append_to_utf_8,
				covers/{EL_READABLE_ZSTRING}.make_from_utf_8
			]"
		local
			z_word, z_str: ZSTRING; utf_8: STRING; conv: EL_UTF_8_CONVERTER
		do
			create utf_8.make_empty
			across Text.lines_32 as line loop
				utf_8.wipe_out
				across line.split (' ') as word loop
					if @ word.cursor_index > 1 then
						utf_8.append_character (' ')
					end
					z_word := word
					z_word.append_to_utf_8 (utf_8)
				end
				if attached conv.string_32_to_string_8 (line) as line_utf_8 then
					assert_same_string (Void, utf_8, line_utf_8)
					z_str := line
					assert_same_string (Void, z_str.to_utf_8, line_utf_8)
				end
			end
		end

end
