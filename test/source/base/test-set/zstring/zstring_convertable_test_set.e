note
	description: "Testing class ${EL_CONVERTABLE_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-14 13:01:30 GMT (Thursday 14th March 2024)"
	revision: "2"

class
	ZSTRING_CONVERTABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	STRING_HANDLER undefine default_create end

	EL_SHARED_TEST_TEXT

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["split",		  agent test_split],
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
			list: LIST [ZSTRING]; list_32: LIST [STRING_32]
			test: STRING_TEST; i: INTEGER
		do
			create test
			across Text.lines as line loop
				test.set (line.item)
				from i := 1 until i > 3 loop
					list := test.zs.split_list (test.s_32 [i])
					list_32 := test.s_32.split (test.s_32 [i])
					assert ("same count", list.count = list_32.count)
					if list.count = list_32.count then
						assert ("same content", across list as ls all ls.item.same_string (list_32.i_th (ls.cursor_index)) end)
					end
					i := i + 1
				end
			end
		end

	test_to_string_32
		-- ZSTRING_CONVERTABLE_TEST_SET.test_to_string_32
		note
			testing:	"[
				covers/{EL_CONVERTABLE_ZSTRING}.to_string_32,
				covers/{EL_CONVERTABLE_ZSTRING}.make_from_general
			]"
		local
			test: STRING_TEST
		do
			create test
			across Text.lines as line loop
				test.set (line.item)
				assert ("strings equal", test.is_same)
			end
		end

	test_to_utf_8
		-- ZSTRING_TEST_SET.test_to_utf_8
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
			across Text.lines as line loop
				utf_8.wipe_out
				across line.item.split (' ') as word loop
					if word.cursor_index > 1 then
						utf_8.append_character (' ')
					end
					z_word := word.item
					z_word.append_to_utf_8 (utf_8)
				end
				if attached conv.string_32_to_string_8 (line.item) as line_utf_8 then
					assert_same_string (Void, utf_8, line_utf_8)
					z_str := line.item
					assert_same_string (Void, z_str.to_utf_8, line_utf_8)
				end
			end
		end

end