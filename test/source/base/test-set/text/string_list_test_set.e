note
	description: "Test lists conforming to ${EL_STRING_CHAIN [STRING_GENERAL]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-22 8:13:57 GMT (Tuesday 22nd April 2025)"
	revision: "2"

class STRING_LIST_TEST_SET inherit BASE_EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["append_substrings", agent test_append_substrings],
				["curtail_list",		 agent test_curtail_list],
				["linked_list",		 agent test_linked_list],
				["unique_sort",		 agent test_unique_sort]
			>>)
		end

feature -- Tests

	test_append_substrings
		-- STRING_LIST_TEST_SET.test_append_substrings
		note
			testing: "[
				covers/{EL_STRING_CHAIN}.append_substrings,
				covers/{EL_STRING_CHAIN}.make_from_substrings
			]"
		local
			date_parts: EL_STRING_8_LIST
		do
			create date_parts.make_from_substrings ("IMG-20210611-WA0000.jpeg", 5, << 4, 2, 2 >>)
			assert ("valid character count", date_parts.character_count = 8)
			assert ("valid year", date_parts [1].to_integer = 2021)
			assert ("valid month", date_parts [2].to_integer = 6)
			assert ("valid day", date_parts [3].to_integer = 11)
		end

	test_curtail_list
		-- STRING_LIST_TEST_SET.test_curtail_list
		note
			testing: "[
				covers/{EL_STRING_LIST}.curtail,
				covers/{EL_STRING_LIST}.keep_character_head,
				covers/{EL_STRING_LIST}.keep_character_tail
			]"
		local
			line_list: EL_ZSTRING_LIST; dots_index, tail_index: INTEGER
			meets_expectation: BOOLEAN
		do
			if attached Text.lines_32 as text_lines then
				across 1 |..| text_lines.count as count loop
					create line_list.make_from_general (Text.lines_32.sub_list (1, count.item))
					line_list.curtail (100, 80)
					if attached line_list.joined_strings as joined then
						dots_index := joined.substring_index ("..", 1)
						if dots_index > 0 then
							tail_index := dots_index + 4
							meets_expectation := (joined.count - tail_index + 1) + dots_index - 1 = 100
						else
							meets_expectation := joined.count <= 100
						end
						if not meets_expectation then
							lio.put_labeled_lines ("Curtailed", line_list)
							lio.put_new_line
							failed ("curtailed to 100 characters leaving 80%% at head")
						end
					end
				end
			end
		end

	test_linked_list
		-- STRING_LIST_TEST_SET.test_linked_list
		note
			testing: "[
				covers/{EL_READABLE_STRING_CHAIN}.longest_count
			]"
		local
			linked_list: EL_LINKED_STRING_LIST [STRING_8]
		do
			create linked_list.make_from (Text.latin_1_list)
			assert ("longest is ", linked_list.longest_count = 63)
		end

	test_unique_sort
		-- STRING_TEST_SET.test_unique_sort
		note
			testing: "[
				covers/{EL_STRING_CHAIN}.sort,
				covers/{EL_STRING_CHAIN}.unique_sort
			]"
		local
			list_1, list_2: EL_STRING_8_LIST
		do
			list_1 := "zebra, pig, horse, dog, cat"
			create list_2.make (list_1.count * 2)
			across list_1 as list loop
				list_2.extend (list.item)
				if list.cursor_index \\ 2 = 0 then
					list_2.extend (list.item)
				end
			end
			list_2.unique_sort
			list_1.sort (True)
			assert ("cat first", list_1.first ~ "cat")
			assert ("zebra last", list_1.last ~ "zebra")
			assert ("same lists", list_1 ~ list_2)
		end

end