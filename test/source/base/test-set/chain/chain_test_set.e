note
	description: "Test set for [$source EL_CHAIN] and related classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-03 0:11:21 GMT (Friday 3rd January 2020)"
	revision: "5"

class
	CHAIN_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_LIO

feature -- Test

	test_weight_summation_1
		-- using method 1
		note
			testing: "covers/{EL_CHAIN_SUMMATOR}.sum"
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
			testing: "covers/{EL_CHAIN}.query_is_equal", "covers/{EL_CHAIN}.agent_query", "covers/{EL_CHAIN}.query"
		do
			assert ("sum red is 14", Widget_list.query_if (agent {WIDGET}.is_color (Red)).sum_integer (agent {WIDGET}.weight) = 14)
			assert ("sum blue is 8", Widget_list.query_is_equal (Blue, agent {WIDGET}.color).sum_integer (agent {WIDGET}.weight) = 8)
		end

	test_string_list
		local
			color_list: STRING
		do
			color_list := "Red,Blue,Green,Blue,Red"
			assert ("same colors", Widget_list.string_8_list (agent {WIDGET}.color_name).joined (',') ~ color_list)
		end

	test_mapping
		local
			key_list: EL_ARRAYED_LIST [INTEGER]
		do
			key_list := Widget_list.query_if (agent {WIDGET}.is_color (Red)).integer_map_list (agent {WIDGET}.weight).key_list
			assert ("red weights are: 2, 12", key_list.to_array ~ << 2, 12 >>)

			key_list := Widget_list.query (color_is (Blue)).integer_map_list (agent {WIDGET}.weight).key_list
			assert ("blue weights are: 3, 5", key_list.to_array ~ << 3, 5 >>)

			key_list := Widget_list.query (color_is (Green)).integer_map_list (agent {WIDGET}.weight).key_list
			assert ("green weight is: 1", key_list.to_array ~ << 1 >>)
		end

	test_order_by_color_name
		local
			previous: STRING
		do
			previous := "0"
			across Widget_list.ordered_by (agent {WIDGET}.color_name, True) as widget loop
				lio.put_labeled_string (widget.item.out, widget.item.color_name)
				lio.put_new_line
				assert ("color_name >= previous", widget.item.color_name >= previous)
				previous := widget.item.color_name
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

	test_find_predicate
		do
			Widget_list.find_first_true (agent {WIDGET}.is_color (Blue))
			assert ("item weight is 3", Widget_list.item.weight = 3)

			Widget_list.find_next_true (agent {WIDGET}.is_color (Blue))
			assert ("item weight is 5", Widget_list.item.weight = 5)

			Widget_list.find_first_equal (1, agent {WIDGET}.weight)
			assert ("item color is green", Widget_list.item.color = Green)
		end

feature {NONE} -- Implementation

	weight_sum_meeting_1 (widgets: EL_CHAIN [WIDGET]; condition: EL_QUERY_CONDITION [WIDGET]): INTEGER
		-- sum of widget-weights for widgets meeting `condition' (method 1)
		local
			summator: EL_CHAIN_SUMMATOR [WIDGET, INTEGER]
		do
			create summator
			Result := summator.sum (widgets.query (condition), agent {WIDGET}.weight)
		end

	weight_sum_meeting_2 (widgets: EL_CHAIN [WIDGET]; condition: EL_QUERY_CONDITION [WIDGET]): INTEGER
		-- sum of widget-weights for widgets meeting `condition' (method 2)
		do
			Result := widgets.sum_integer_meeting (agent {WIDGET}.weight, condition)
		end

	color_is (color: INTEGER): EL_PREDICATE_QUERY_CONDITION [WIDGET]
		do
			Result := agent {WIDGET}.is_color (color)
		end

	any_color: EL_ANY_QUERY_CONDITION [WIDGET]
		do
			create Result
		end

feature {NONE} -- Constants

	Red: INTEGER = 1

	Blue: INTEGER = 2

	Green: INTEGER = 3

	Widget_list: EL_ARRAYED_LIST [WIDGET]
		once
			create Result.make_from_array (<<
				[Red, 2], [Blue, 3], [Green, 1], [Blue, 5], [Red, 12]
			>>)
		end

end
