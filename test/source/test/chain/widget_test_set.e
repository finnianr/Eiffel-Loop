note
	description: "[
		An experiment to show how it might be possible to achieve Java-like stream functionality in Eiffel
		by reproducing the following example:
		
			int sum = widgets.stream().filter(w -> w.getColor() == RED)
												.mapToInt(w -> w.getWeight())
												.sum();
                      
       See: [https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html java/util/stream/Stream]
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WIDGET_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test

	test_weight_summation_1
		-- using method 1
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
		do
			assert ("sum red is 14", Widget_list.agent_query (agent {WIDGET}.is_color (Red)).sum_integer (agent {WIDGET}.weight) = 14)
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
			key_list := Widget_list.agent_query (agent {WIDGET}.is_color (Red)).integer_map_list (agent {WIDGET}.weight).key_list
			assert ("red weights are: 2, 12", key_list.to_array ~ << 2, 12 >>)

			key_list := Widget_list.query (color_is (Blue)).integer_map_list (agent {WIDGET}.weight).key_list
			assert ("blue weights are: 3, 5", key_list.to_array ~ << 3, 5 >>)

			key_list := Widget_list.query (color_is (Green)).integer_map_list (agent {WIDGET}.weight).key_list
			assert ("green weight is: 1", key_list.to_array ~ << 1 >>)
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
