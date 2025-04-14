note
	description: "Immutable string manager test SET"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-14 7:54:02 GMT (Monday 14th April 2025)"
	revision: "2"

class
	IMMUTABLE_STRING_MANAGER_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_SHARED_TEST_TEXT

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["set_item",			 agent test_set_item],
				["set_adjusted_item", agent test_set_adjusted_item],
				["shared_substring",	 agent test_shared_substring]
			>>)
		end

feature -- Tests

	test_set_adjusted_item
		-- IMMUTABLE_STRING_MANAGER_TEST_SET.test_set_adjusted_item
		note
			testing: "[
				covers/{EL_IMMUTABLE_STRING_MANAGER}.set_adjusted_item
			]"
		local
			str, adjusted: STRING_8; manager_8: EL_IMMUTABLE_8_MANAGER
		do
			create manager_8
			across << "  abc  ", "abc", " abc", "abc ", "" >> as list loop
				str := list.item
				adjusted := str.twin
				adjusted.adjust
				manager_8.set_adjusted_item (str.area, 0, str.count, {EL_SIDE}.Both)
				assert_same_string ("adjusted immutable", manager_8.item, adjusted)
			end
		end

	test_set_item
		-- IMMUTABLE_STRING_MANAGER_TEST_SET.test_set_item
		note
			testing: "[
				covers/{EL_IMMUTABLE_STRING_MANAGER}.set_item,
				covers/{EL_IMMUTABLE_STRING_MANAGER}.new_substring
			]"
		local
			manager_32: EL_IMMUTABLE_32_MANAGER; manager_8: EL_IMMUTABLE_8_MANAGER
			word_8: STRING_8; word_32: STRING_32; word_index: INTEGER
		do
			create manager_32; create manager_8
			across Text.lines_32 as line loop
				if attached line.item as str_32 then
					if str_32.is_valid_as_string_8 and then attached str_32.to_string_8 as str_8 then
						if attached str_8.split (' ') as words then
							word_8 := words [2]
							word_index := line.item.substring_index (word_8, 1)
							if attached super_8 (str_8) as super then
								manager_8.set_item (super.area, word_index - 1, word_8.count)
								assert_same_string (Void, manager_8.item, word_8)
								word_8 := words [1]
	--						same as first word
								assert_same_string (Void, manager_8.new_substring (super.area, 0, word_8.count), word_8)
							end
						end
					elseif attached str_32.split (' ') as words then
						word_32 := words [2]
						word_index := line.item.substring_index (word_32, 1)
						if attached super_32 (line.item) as super then
							manager_32.set_item (super.area, word_index - 1, word_32.count)
							assert_same_string (Void, manager_32.item, word_32)
							word_32 := words [1]
	--						same as first word
							assert_same_string (Void, manager_32.new_substring (super.area, 0, word_32.count), word_32)
						end
					end
				end
			end
		end

	test_shared_substring
		-- IMMUTABLE_STRING_MANAGER_TEST_SET.test_shared_substring
		local
			manager_32: EL_IMMUTABLE_32_MANAGER; manager_8: EL_IMMUTABLE_8_MANAGER
			line_32: STRING_32; substring_32: IMMUTABLE_STRING_32
		do
			create manager_32; create manager_8
			across Text.lines_32 as line loop
				if attached line.item as str_32 then
					if str_32.is_valid_as_string_8 and then attached str_32.to_string_8 as str_8 then

					else
						line_32 := str_32.twin
						substring_32 := manager_32.shared_substring (str_32, 1, str_32.index_of (' ', 1) - 1)
						assert_same_string (Void, super_32 (str_32).substring_to (' '), substring_32)
						assert_same_string ("str_32 unchanged", str_32, line_32)
					end
				end
			end
		end

end