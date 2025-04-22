note
	description: "Test set for ${EL_CONTAINER_STRUCTURE} descendants and related classes"
	notes: "[
		Covers various routines from the following:

		* ${EL_CONTAINER_STRUCTURE}
		* ${EL_ARRAYED_RESULT_LIST}
		* ${EL_ARRAYED_LIST}
		* ${EL_QUERY_CONDITION}
		* ${EL_CONTAINER_ARITHMETIC}
		* ${EL_PREDICATE_QUERY_CONDITION}
		* ${EL_ANY_QUERY_CONDITION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-22 8:21:12 GMT (Tuesday 22nd April 2025)"
	revision: "59"

class
	CONTAINER_STRUCTURE_TEST_SET

inherit
	CONTAINER_EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["arrayed_result_list",			agent test_arrayed_result_list],
				["derived_list",					agent test_derived_list],
				["find_linear_position",		agent test_find_linear_position],
				["integer_functions",			agent test_integer_functions],
				["order_by_color_name",			agent test_order_by_color_name],
				["order_by_descending_width",	agent test_order_by_descending_width],
				["query_and_summation",			agent test_query_and_summation],
				["string_8_list",					agent test_string_8_list],
				["arrayed_map_group_sort",		agent test_arrayed_map_group_sort],
				["arrayed_map_list",				agent test_arrayed_map_list],
				["arrayed_map_sort",				agent test_arrayed_map_sort],
				["circular_indexing",			agent test_circular_indexing],
				["container_sum",					agent test_container_sum],
				["file_line_source",				agent test_file_line_source],
				["make_filtered_array",			agent test_make_filtered_array],
				["result_list_character",		agent test_result_list_character],
				["result_list_string",			agent test_result_list_string],
				["structure_slicing",			agent test_structure_slicing]
			>>)
		end

feature -- WIDGET Tests

	test_arrayed_result_list
		note
			testing: "[
				covers/{EL_CONTAINER_STRUCTURE}.to_special,
				covers/{EL_ARRAYED_RESULT_LIST}.make,
				covers/{EL_ARRAYED_RESULT_LIST}.make_with_tuple_2,
				covers/{EL_CONTAINER_STRUCTURE}.query_if
			]"
		local
			key_list: EL_ARRAYED_RESULT_LIST [WIDGET, INTEGER]
		do
			Widget_list.start
			if attached Widget_list.query_if (agent {WIDGET}.is_color (Color.red)) as red_list then
				assert ("index is 1", Widget_list.index = 1)
				key_list := [red_list, agent {WIDGET}.width]
				assert ("red widths are: 200, 1200", key_list.to_array ~ << 200, 1200 >>)
			end
			if attached Widget_list.query (color_is (Color.blue)) as blue_list then
				assert ("index is 1", Widget_list.index = 1)
				key_list := [blue_list, agent {WIDGET}.width]
				assert ("blue widths are: 300, 500", key_list.to_array ~ << 300, 500 >>)
			end
		end

	test_derived_list
		-- CONTAINER_STRUCTURE_TEST_SET.test_derived_list
		note
			testing: "[
				covers/{EL_CONTAINER_STRUCTURE}.new_special,
				covers/{EL_CONTAINER_STRUCTURE}.derived_list,
				covers/{EL_CONTAINER_STRUCTURE}.derived_list_meeting,
				covers/{EL_INITIALIZED_ARRAYED_LIST_FACTORY}.new_list,
				covers/{EL_INITIALIZED_OBJECT_FACTORY}.new_generic_type_factory
			]"
		do
			if attached {EL_ARRAYED_LIST [INTEGER]}
				Widget_list.derived_list (agent {WIDGET}.width) as width_list
			then
				assert ("same count", width_list.count = Widget_list.count)
				across Widget_list as widget loop
					lio.put_line (widget.item.out)
					assert ("same width", widget.item.width = width_list [widget.cursor_index])
				end
			else
				failed ("create width_list")
			end
			if attached {EL_ARRAYED_LIST [INTEGER]}
					Widget_list.derived_list_if (agent {WIDGET}.width, agent {WIDGET}.is_color (Color.blue))
				as blue_width_list
			then
				assert ("2 results", blue_width_list.count = 2)
				assert ("first is 300", blue_width_list.first = 300)
				assert ("last is 500", blue_width_list.last = 500)
			else
				failed ("create width_list")
			end

			assert ("same list", Widget_list.derived_list (agent {WIDGET}.color) ~ widget_colors)
		end

	test_find_linear_position
		note
			testing: "[
				covers/{EL_LINEAR}.index_of,
				covers/{EL_LINEAR}.find_first_true,
				covers/{EL_LINEAR}.find_next_true,
				covers/{EL_LINEAR}.find_first_equal
			]"
		do
			Widget_list.find_first_true (agent {WIDGET}.is_color (Color.blue))
			assert_found ("first blue is 300", Widget_list, Widget_list.item.width = 300)

			Widget_list.find_next_true (agent {WIDGET}.is_color (Color.blue))
			assert_found ("next blue is 500", Widget_list, Widget_list.item.width = 500)

			Widget_list.find_first_equal (1200, agent {WIDGET}.width)
			assert_found ("first 1200 width has color red", Widget_list, Widget_list.item.color = Color.red)

			Widget_list.start
			assert ("3rd position", Widget_list.index_of (Widget_list [3], 1) = 3)
			assert ("index is 1", Widget_list.index = 1)
		end

	test_integer_functions
		-- CONTAINER_STRUCTURE_TEST_SET.test_integer_functions
		note
			testing: "[
				covers/{EL_CUMULATIVE_CONTAINER_ARITHMETIC}.max_integer,
				covers/{EL_CUMULATIVE_CONTAINER_ARITHMETIC}.min_integer,
				covers/{EL_CUMULATIVE_CONTAINER_ARITHMETIC}.sum_integer,
				covers/{EL_CONTAINER_ARITHMETIC}.max_meeting,
				covers/{EL_CONTAINER_ARITHMETIC}.min_meeting,
				covers/{EL_CONTAINER_ARITHMETIC}.sum_meeting
			]"
		do
			assert ("max width is 1200", Widget_list.max_integer (agent {WIDGET}.width) = 1200)
			assert ("min width is 100", Widget_list.min_integer (agent {WIDGET}.width) = 100)
			assert ("sum of widths is 2300", Widget_list.sum_integer (agent {WIDGET}.width) = 2300)
		end

	test_order_by_color_name
		-- CONTAINER_STRUCTURE_TEST_SET.test_order_by_color_name
		note
			testing: "[
				covers/{EL_IMMUTABLE_NAME_TABLE}.make,
				covers/{EL_ARRAYED_LIST}.order_by,
				covers/{EL_CHAIN}.ordered_by
			]"
		local
			previous: STRING; ordered_1, ordered_2: like Widget_list
		do
			ordered_1 := Widget_list.ordered_by (agent {WIDGET}.color_name, True)

			create ordered_2.make_from (Widget_list)
			ordered_2.start
			ordered_2.order_by (agent {WIDGET}.color_name, True)

			across << ordered_1, ordered_2 >> as ordered loop
				previous := "0"
				if ordered.item = ordered_1 then
					lio.put_line ("Widget_list.ordered_by")
				else
					lio.put_line ("ordered_2.order_by")
				end
				across ordered.item as widget loop
					lio.put_line (widget.item.color_name)
					assert ("color_name >= previous", widget.item.color_name >= previous)
					previous := widget.item.color_name
				end
				lio.put_new_line
			end
		end

	test_order_by_descending_width
		local
			previous: INTEGER
		do
			previous := previous.Max_value
			across Widget_list.ordered_by (agent {WIDGET}.width, False) as widget loop
				assert ("width <= previous", widget.item.width <= previous)
				previous := widget.item.width
			end
		end

	test_query_and_summation
		-- CONTAINER_STRUCTURE_TEST_SET.test_query_and_summation
		note
			testing: "[
				covers/{EL_CONTAINER_ARITHMETIC}.sum_meeting,
				covers/{EL_INTEGER_32_RESULT}.add,
				covers/{EL_OR_QUERY_CONDITION}.met,
				covers/{EL_NOT_QUERY_CONDITION}.met,
				covers/{EL_ANY_QUERY_CONDITION}.met,
				covers/{EL_FUNCTION_VALUE_QUERY_CONDITION}.met,
				covers/{EL_CONTAINER_STRUCTURE}.query_is_equal,
				covers/{EL_CONTAINER_STRUCTURE}.query
			]"
		local
			condition_sum_map_list: EL_ARRAYED_MAP_LIST [EL_QUERY_CONDITION [WIDGET], INTEGER]
			sum_2, sum_3: INTEGER; is_width_300: EL_PREDICATE_QUERY_CONDITION [WIDGET]
		do
			is_width_300 := agent widget_has_width (?, 300)

			create condition_sum_map_list.make_from_array (<<
				[color_is (Color.red), 1400],
				[color_is (Color.blue), 800],
				[color_is (Color.blue) and is_width_300, 300],
				[color_is (Color.blue) or color_is (Color.red), 2200],
				[not color_is (Color.green), 2200],
				[any_widget, 2300]
			>>)

			Widget_list.start
			across condition_sum_map_list as map loop
				if attached map.key as condition and then attached map.value as sum_value then
					sum_2 := Widget_list.sum_integer_meeting (agent {WIDGET}.width, condition)
					if attached Widget_list.query (condition) as subset then
						sum_3 := subset.sum_integer (agent {WIDGET}.width)
					end
					assert ("same sum", sum_value = sum_2 and sum_value = sum_3)
				end
				assert ("index unchanged", Widget_list.index = 1)
			end
			if attached Widget_list.query_is_equal (Color.blue, agent {WIDGET}.color) as blue_list then
				assert ("sum blue is 800", blue_list.sum_integer (agent {WIDGET}.width) = 800)
			end
		end

	test_string_8_list
		note
			testing: "[
				covers/{EL_CONTAINER_STRUCTURE}.string_8_list
				covers/{EL_CONTAINER_STRUCTURE}.new_special,
				covers/{EL_CONTAINER_STRUCTURE}.derived_list,
				covers/{EL_INITIALIZED_ARRAYED_LIST_FACTORY}.new_list,
				covers/{EL_INITIALIZED_OBJECT_FACTORY}.new_generic_type_factory
			]"
		do
			if attached Widget_list.string_8_list (agent {WIDGET}.color_name) as color_name_list then
				assert_same_string (Void, color_name_list.joined (','), "red,blue,green,blue,red")
			end
		end

feature -- Test

	test_arrayed_map_group_sort
		-- CONTAINER_STRUCTURE_TEST_SET.test_arrayed_map_group_sort
		note
			testing: "[
				covers/{EL_ARRAYED_MAP_LIST}.sort_by_key_then_value,
				covers/{EL_PLAIN_TEXT_FILE}.new_line_list
			]"
		local
			word_set: EL_HASH_SET [STRING]; length_to_word_map: EL_ARRAYED_MAP_LIST [INTEGER, STRING]
			word_list: EL_STRING_8_LIST; previous_key: INTEGER; previous_value, sort_order: STRING
		do
			create word_set.make_equal (500)
			across Hexagram.English_titles as title loop
				create word_list.make_split (title.item, ' ')
				across word_list as list loop
					if attached list.item as word then
						word.prune_all (',')
						word_set.put (word)
					end
				end
			end
			create length_to_word_map.make (word_set.count)
			across word_set as set loop
				length_to_word_map.extend (set.item.count, set.item)
			end

			if attached length_to_word_map as map then
				across << True, False >> as ascending_value loop
					sort_order := if ascending_value.item then "ascending" else "descending" end
					lio.put_labeled_string ("sorting word count groups", sort_order)
					lio.put_new_line
					map.sort_by_key_then_value (True, ascending_value.item)
					previous_key := map.i_th_key (1); previous_value := map.i_th_value (1)
					from map.go_i_th (2) until map.after loop
						if map.item_key = previous_key then
							if ascending_value.item then
								assert (sort_order + " word order", map.item_value > previous_value)
							else
								assert (sort_order + " word order", map.item_value < previous_value)
							end
						else
							assert ("ascending word count", map.item_key > previous_key)
							previous_key := map.item_key
							previous_value := map.item_value
						end
						map.forth
					end
				end
			end
		end

	test_arrayed_map_list
		-- CONTAINER_STRUCTURE_TEST_SET.test_arrayed_map_list
		note
			testing: "[
				covers/{EL_CONTAINER_STRUCTURE}.to_special,
				covers/{EL_ARRAYED_MAP_LIST}.make_from_keys,
				covers/{EL_ARRAYED_MAP_LIST}.make_from_values,
				covers/{EL_HASH_SET}.make_from
			]"
		local
			string_to_character_map: EL_ARRAYED_MAP_LIST [STRING, CHARACTER]
			character_to_code_map: EL_ARRAYED_MAP_LIST [CHARACTER, NATURAL]
			character_set: EL_HASH_SET [CHARACTER]
		do
			create character_set.make_from (Character_string, False)
			across new_character_containers as list loop
				if attached list.item as container then
					lio.put_labeled_string ("Type", container.generator)
					lio.put_new_line
					create character_to_code_map.make_from_keys (container, agent ascii_code)
					character_to_code_map.compare_objects

					assert ("same count", character_to_code_map.count >= character_set.count)
					across Character_string as str loop
						assert ("has character->code pair", character_to_code_map.has ([str.item, str.item.natural_32_code]))
					end
					create string_to_character_map.make_from_values (container, agent to_character_string)
					string_to_character_map.compare_objects

					assert ("same count", string_to_character_map.count >= character_set.count)
					across Character_string as str loop
						assert ("has string->character pair", string_to_character_map.has ([str.item.out, str.item]))
					end
				end
			end
		end

	test_arrayed_map_sort
		-- CONTAINER_STRUCTURE_TEST_SET.test_arrayed_map_sort
		local
			name_list: EL_ARRAYED_MAP_LIST [IMMUTABLE_STRING_32, IMMUTABLE_STRING_32]
			sorted_names: SORTABLE_ARRAY [IMMUTABLE_STRING_32]; names: HEXAGRAM_NAMES
			name_table: HASH_TABLE [IMMUTABLE_STRING_32, IMMUTABLE_STRING_32]
			i: INTEGER
		do
			create name_list.make (64)
			create name_table.make_equal (64)
--			hexagram 10 and 56 have the same pinyin name
			from i := 1 until i > 64 loop
				name_list.extend (names.i_th_hanzi_characters (i), names.i_th_pinyin_name (i))
				name_table.extend (names.i_th_pinyin_name (i), names.i_th_hanzi_characters (i))
				i := i + 1
			end
--			Test key sorting
			create sorted_names.make_from_array (name_list.key_list.to_array)
			sorted_names.sort

			name_list.sort_by_key (True)
			if attached name_list as list then
				from list.start until list.after loop
					assert ("same hanzi", list.item_key ~ sorted_names [list.index])
					assert ("same pinyin", list.item_value ~ name_table [list.item_key])
					list.forth
				end
			end

--			Test value sorting
			create sorted_names.make_from_array (name_list.value_list.to_array)
			sorted_names.sort

			name_list.sort_by_value (True)
			if attached name_list as list then
				from list.start until list.after loop
					assert ("same pinyin", list.item_value ~ sorted_names [list.index])
					assert ("same pinyin", list.item_value ~ name_table [list.item_key])
					list.forth
				end
			end
		end

	test_circular_indexing
		local
			list: EL_ARRAYED_LIST [INTEGER]
			sum, one, i: INTEGER
		do
			create list.make_from_array (<< 1, 2, 3 >>)
			across -3 |..| 2 as n loop
				sum := sum + list.circular_i_th (n.item)
			end
			assert ("sum is 12", sum = 12)

			from one := -1 until one > 1 loop
				list.start
				list.circular_move (list.count * one)
				assert ("same position", list.item = 1)
				one := one + 2
			end
			-- reverse iteration
			from i := 1 until i > list.count loop
				assert ("same item", list.i_th (list.count - (i - 1)) = list.circular_i_th (i.opposite))
				i := i + 1
			end
		end

	test_container_sum
		-- CONTAINER_STRUCTURE_TEST_SET.test_container_sum
		note
			testing: "[
				covers/{EL_CONTAINER_ARITHMETIC}.sum_meeting,
				covers/{EL_CONTAINER_CONVERSION}.as_structure
			]"
		local
			summator: EL_CONTAINER_ARITHMETIC [CHARACTER, INTEGER]
			wrapper: EL_CONTAINER_WRAPPER [CHARACTER]
		do
			across new_character_containers as list loop
				if attached list.item as container then
					lio.put_labeled_string ("Type", container.generator)
					lio.put_new_line
					create summator.make (as_structure (container))
					assert ("sum is 6", summator.sum_meeting (agent to_integer, character_is_digit) = 6 )
				end
			end
		end

	test_file_line_source
		note
			testing: "[
				covers/{EL_CUMULATIVE_CONTAINER_ARITHMETIC}.sum_integer_meeting,
				covers/{EL_SPLIT_READABLE_STRING_LIST}.do_meeting
			]"
		local
			line_source: EL_PLAIN_TEXT_LINE_SOURCE; boot_lines: EL_ZSTRING_LIST
			boot: EL_ZSTRING; base_set: EL_HASH_SET [EL_ZSTRING]; path: FILE_PATH
			step_count: INTEGER; has_boot: EL_PREDICATE_QUERY_CONDITION [ZSTRING]
			split_list: EL_SPLIT_ZSTRING_LIST; counter: INTEGER_REF
			add_step_count: EL_CALL_PROCEDURE_ACTION [ZSTRING]
		do
			create line_source.make_utf_8 (Dev_environ.El_test_data_dir + "txt/help-files.txt")
			boot := "/boot/"

			assert ("total step count is 64", line_source.sum_integer (agent path_step_count) = 64)

			has_boot := agent line_has_word (?, boot)
			step_count := line_source.sum_integer_meeting (agent path_step_count, has_boot)
			assert ("total step count with %"/boot/%" is 12", step_count = 12)

			create boot_lines.make_from_if (line_source, agent line_has_word (?, boot))
			lio.put_labeled_lines ("has step %"/boot/%"", boot_lines)
			assert ("3 boot lines", boot_lines.count = 3)

			create base_set.make_equal (boot_lines.count)
			across boot_lines as line loop
				path := line.item
				base_set.put (path.base)
			end
			assert ("3 base names", base_set.count = 3)

			create split_list.make (boot_lines.joined_lines, '%N')
			create counter
			create add_step_count.make (agent add_path_step_count (?, counter))
			split_list.do_for_all (add_step_count)
			assert ("step count is ", counter.item = 12)
		end

	test_make_filtered_array
		note
			testing: "covers/{EL_ARRAYED_LIST}.make_from_for"
		local
			arrayed_list: EL_ARRAYED_LIST [CHARACTER]
		do
			across new_character_containers as list loop
				if attached list.item as container then
					lio.put_labeled_string ("Type", container.generator)
					lio.put_new_line
					create arrayed_list.make_from_if (container, agent is_character_digit)

					assert ("same digits", arrayed_list.to_array ~ << '1', '2' , '3' >>)
				end
			end
		end

	test_result_list_character
		-- CONTAINER_STRUCTURE_TEST_SET.test_result_list_character
		note
			testing: "[
				covers/{EL_ARRAYED_RESULT_LIST}.make_from_for,
				covers/{EL_CONTAINER_STRUCTURE}.new_special
			]"
		local
			result_list: EL_ARRAYED_RESULT_LIST [CHARACTER, INTEGER]
		do
			across new_character_containers as list loop
				if attached list.item as container then
					if attached {LINEAR [CHARACTER]} container as linear then
						linear.start
					end
					lio.put_labeled_string ("Type", container.generator)
					lio.put_new_line
					create result_list.make_from_for (container, character_is_digit, agent to_integer)
					assert ("array is 1, 2, 3", result_list.to_array ~ << 1, 2, 3 >> )
					if attached {LINEAR [CHARACTER]} container as linear then
						assert ("index = 1", linear.index = 1)
					end
				end
			end
		end

	test_result_list_string
		-- CONTAINER_STRUCTURE_TEST_SET.test_result_list_string
		note
			testing: "[
				covers/{EL_ARRAYED_RESULT_LIST}.make,
				covers/{EL_CONTAINER_STRUCTURE}.new_special
			]"
		local
			result_list: EL_ARRAYED_RESULT_LIST [READABLE_STRING_GENERAL, INTEGER]
			string_array: ARRAY [READABLE_STRING_GENERAL]
		do
			string_array := <<
				create {STRING_8}.make_filled (' ', 1),
				create {STRING_32}.make_filled (' ', 2),
				create {ZSTRING}.make_filled (' ', 3)
			>>
			create result_list.make (string_array, agent {READABLE_STRING_GENERAL}.count)
			assert ("same array", result_list.to_array ~ << 1, 2, 3 >>)
		end

	test_structure_slicing
		note
			testing: "[
				covers/{EL_ARRAYED_LIST}.make_from,
				covers/{EL_CONTAINER_STRUCTURE}.slice,
				covers/{EL_CONTAINER_STRUCTURE}.slice_list,
				covers/{EL_SLICEABLE_SPECIAL}.item
			]"
		local
			abcd_list, cd_list: EL_ARRAYED_LIST [CHARACTER]
			abcd: STRING; ab, cd, empty: SPECIAL [CHARACTER]
		do
			abcd := "abcd"
			create empty.make_empty (0)
			ab := abcd.substring (1, 2).area.resized_area (2)
			create abcd_list.make_from (abcd)
			create cd_list.make_from (abcd.substring (3, 4))

			assert ("first two", abcd_list.slice [0, 1] ~ ab)
			assert ("last two", abcd_list.slice_list (-2, -1) ~ cd_list)
			assert ("entire string", abcd_list.slice [0, -1] ~ abcd_list.area)
			assert ("empty", abcd_list.slice [1, 0] ~ empty)
			assert ("empty", abcd_list.slice [-1, -2] ~ empty)
		end

end