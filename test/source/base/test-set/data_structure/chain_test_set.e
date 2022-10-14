note
	description: "Test set for [$source EL_CHAIN] and related classes"
	notes: "[
		Covers various routines from the following:
		
		* [$source EL_ARRAYED_RESULT_LIST]
		* [$source EL_ARRAYED_LIST]
		* [$source EL_QUERY_CONDITION]
		* [$source EL_RESULT_SUMMATOR]
		* [$source EL_PREDICATE_QUERY_CONDITION]
		* [$source EL_ANY_QUERY_CONDITION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-14 18:51:21 GMT (Friday 14th October 2022)"
	revision: "23"

class
	CHAIN_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO

	EL_SHARED_ZCODEC_FACTORY

	EL_ENCODING_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("circular_indexing", agent test_circular_indexing)
			eval.call ("converted_list", agent test_converted_list)
			eval.call ("find_predicate", agent test_find_predicate)
			eval.call ("index_of", agent test_index_of)
			eval.call ("make_from_keys", agent test_make_from_keys)
			eval.call ("query_and_map_list", agent test_query_and_map_list)
			eval.call ("order_by_color_name", agent test_order_by_color_name)
			eval.call ("order_by_weight", agent test_order_by_weight)
			eval.call ("result_list", agent test_result_list)
			eval.call ("string_list", agent test_string_list)
			eval.call ("weight_summation_1", agent test_weight_summation_1)
			eval.call ("weight_summation_2", agent test_weight_summation_2)
			eval.call ("weight_summation_3", agent test_weight_summation_3)
		end

feature -- Test

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

	test_converted_list
		local
			factory: EL_LIST_FACTORY [STRING, WIDGET];list: LIST [STRING]
		do
			create factory
			list := factory.new_arrayed_list (Widget_list, agent {WIDGET}.color_name)
			assert ("same count", list.count = Widget_list.count)
			across Widget_list as l loop
				assert ("same string", l.item.color_name ~ list [l.cursor_index])
			end
		end

	test_find_predicate
		do
			Widget_list.find_first_true (agent {WIDGET}.is_color (Blue))
			assert ("item weight is 3", Widget_list.item.weight = 3)

			Widget_list.find_next_true (agent {WIDGET}.is_color (Blue))
			assert ("item weight is 5", Widget_list.item.weight = 5)

			Widget_list.find_first_equal (1, agent {WIDGET}.weight)
			assert ("item color is green", Widget_list.item.color = Green)
		end

	test_index_of
		note
			testing: "covers/{EL_LINEAR}.index_of"
		local
			codec: EL_ZCODEC
		do
			codec := Codec_factory.codec_by (Windows | 1250)
			assert ("windows 1250 codec", codec.generating_type ~ {EL_WINDOWS_1250_ZCODEC})
		end

	test_make_from_keys
		note
			testing: "covers/{EL_ARRAYED_MAP_LIST}.make_from_keys"
		local
			code_map: EL_ARRAYED_MAP_LIST [CHARACTER, NATURAL]
			str: STRING
		do
			str := "abc"
			create code_map.make_from_keys (str, agent ascii_code)
			assert ("size is 3", code_map.count = 3)
			from code_map.start until code_map.after loop
				assert ("same letter", code_map.item.key = str [code_map.index])
				assert ("same code", code_map.item.value = str [code_map.index].natural_32_code)
				code_map.forth
			end
		end

	test_order_by_color_name
		local
			previous: STRING; ordered_1, ordered_2: like Widget_list
		do
			ordered_1 := Widget_list.ordered_by (agent {WIDGET}.color_name, True)

			create ordered_2.make_from_array (Widget_list.to_array)
			ordered_2.start
			ordered_2.order_by (agent {WIDGET}.color_name, True)

			across << ordered_1, ordered_2 >> as list loop
				previous := "0"
				if list.item = ordered_1 then
					lio.put_line ("Widget_list.ordered_by")
				else
					lio.put_line ("ordered_2.order_by")
				end
				across list.item as widget loop
					lio.put_line (widget.item.color_name)
					assert ("color_name >= previous", widget.item.color_name >= previous)
					previous := widget.item.color_name
				end
				lio.put_new_line
			end
		end

	test_order_by_weight
		local
			previous: INTEGER
		do
			across Widget_list.ordered_by (agent {WIDGET}.weight, True) as widget loop
				assert ("weight >= previous", widget.item.weight >= previous)
				previous := widget.item.weight
			end
		end

	test_query_and_map_list
		note
			testing: "covers/{EL_ARRAYED_MAP_LIST}.make_from_values",
						"convers/{EL_TRAVERSABLE_STRUCTURE}.query"
		local
			key_list: EL_ARRAYED_LIST [INTEGER]
			color_map: EL_ARRAYED_MAP_LIST [WIDGET, INTEGER]
		do
			Widget_list.start
			if attached Widget_list.query_if (agent {WIDGET}.is_color (Red)) as red_list then
				assert ("index is 1", Widget_list.index = 1)
				key_list := red_list.integer_map_list (agent {WIDGET}.weight).key_list
				assert ("red weights are: 2, 12", key_list.to_array ~ << 2, 12 >>)
			end
			if attached Widget_list.query (color_is (Blue)) as blue_list then
				assert ("index is 1", Widget_list.index = 1)
				key_list := blue_list.integer_map_list (agent {WIDGET}.weight).key_list
				assert ("blue weights are: 3, 5", key_list.to_array ~ << 3, 5 >>)
			end
			if attached Widget_list.query (color_is (Green)) as green_list then
				assert ("index is 1", Widget_list.index = 1)
				key_list := green_list.integer_map_list (agent {WIDGET}.weight).key_list
				assert ("green weight is: 1", key_list.to_array ~ << 1 >>)
			end
		end

	test_result_list
		local
			result_list: EL_ARRAYED_RESULT_LIST [INTEGER, WIDGET]
		do
			result_list := [Widget_list, agent {WIDGET}.color]
			assert ("same color list", across widget_colors as color all result_list [color.cursor_index] = color.item end)
		end

	test_string_list
		local
			color_list: STRING
		do
			color_list := "Red,Blue,Green,Blue,Red"
			assert ("same colors", Widget_list.string_8_list (agent {WIDGET}.color_name).joined (',') ~ color_list)
		end

	test_weight_summation_1
		-- using method 1
		note
			testing: "covers/{EL_RESULT_SUMMATOR}.sum"
		do
			assert ("sum red is 14",			weight_sum_meeting_1 (Widget_list, color_is (Red)) = 14)
			assert ("sum blue is 8", 			weight_sum_meeting_1 (Widget_list, color_is (Blue)) = 8)
			assert ("sum red OR blue is 22", weight_sum_meeting_1 (Widget_list, color_is (Blue) or color_is (Red)) = 22)
			assert ("sum NOT green is 22", 	weight_sum_meeting_1 (Widget_list, not color_is (Green)) = 22)
			assert ("sum any color is 23", 	weight_sum_meeting_1 (Widget_list, any_color) = 23)
		end

	test_weight_summation_2
		-- using method 2
		do
			assert ("sum red is 14",			weight_sum_meeting_2 (Widget_list, color_is (Red)) = 14)
			assert ("sum blue is 8", 			weight_sum_meeting_2 (Widget_list, color_is (Blue)) = 8)
			assert ("sum red OR blue is 22", weight_sum_meeting_2 (Widget_list, color_is (Blue) or color_is (Red)) = 22)
			assert ("sum NOT green is 22", 	weight_sum_meeting_2 (Widget_list, not color_is (Green)) = 22)
			assert ("sum any color is 23", 	weight_sum_meeting_2 (Widget_list, any_color) = 23)
		end

	test_weight_summation_3
		-- using method 2
		note
			testing: "covers/{EL_CHAIN}.query_is_equal, covers/{EL_CHAIN}.query_if",
						"covers/{EL_CHAIN}.query, covers/{EL_FUNCTION_VALUE_QUERY_CONDITION}.met"
		do
			assert (
				"sum red is 14",
				Widget_list.query_if (agent {WIDGET}.is_color (Red)).sum_integer (agent {WIDGET}.weight) = 14
			)
			assert (
				"sum blue is 8",
				Widget_list.query_is_equal (Blue, agent {WIDGET}.color).sum_integer (agent {WIDGET}.weight) = 8
			)
		end

feature {NONE} -- Implementation

	any_color: EL_ANY_QUERY_CONDITION [WIDGET]
		do
			create Result
		end

	ascii_code (c: CHARACTER): NATURAL
		do
			Result := c.natural_32_code
		end

	color_is (color: INTEGER): EL_PREDICATE_QUERY_CONDITION [WIDGET]
		do
			Result := agent {WIDGET}.is_color (color)
		end

	weight_sum_meeting_1 (widgets: EL_CHAIN [WIDGET]; condition: EL_QUERY_CONDITION [WIDGET]): INTEGER
		-- sum of widget-weights for widgets meeting `condition' (method 1)
		local
			summator: EL_RESULT_SUMMATOR [WIDGET, INTEGER]
		do
			widgets.start
			create summator
			Result := summator.sum (widgets.query (condition), agent {WIDGET}.weight)
			assert ("index is 1", widgets.index = 1)
		end

	weight_sum_meeting_2 (widgets: EL_CHAIN [WIDGET]; condition: EL_QUERY_CONDITION [WIDGET]): INTEGER
		-- sum of widget-weights for widgets meeting `condition' (method 2)
		do
			widgets.start
			Result := widgets.sum_integer_meeting (agent {WIDGET}.weight, condition)
			assert ("index is 1", widgets.index = 1)
		end

	widget_colors: EL_ARRAYED_LIST [INTEGER]
		do
			create Result.make (10)
			across Widget_list as widget loop
				Result.extend (widget.item.color)
			end
		end

feature {NONE} -- Constants

	Blue: INTEGER = 2

	Green: INTEGER = 3

	Red: INTEGER = 1

	Widget_list: EL_ARRAYED_LIST [WIDGET]
		once
			create Result.make_from_array (<<
				[Red, 2], [Blue, 3], [Green, 1], [Blue, 5], [Red, 12]
			>>)
		end

end