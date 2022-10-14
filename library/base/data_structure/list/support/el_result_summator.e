note
	description: "[
		Object to add together the [$source NUMERIC] results of a function applied to a
		[$source TRAVERSABLE [G]] list of items filtered by an optional query condition
		[$source EL_QUERY_CONDITION [G]].
	]"
	tests: "Class [$source CHAIN_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-14 16:54:18 GMT (Friday 14th October 2022)"
	revision: "10"

class
	EL_RESULT_SUMMATOR [G, N -> NUMERIC]

inherit
	EL_TRAVERSABLE_STRUCTURE [G]
		export
			{NONE} all
		end

feature -- Access

	sum (list: TRAVERSABLE [G]; value: FUNCTION [G, N]): N
		-- sum of `value' function across all items of `chain'
		do
			Result := sum_meeting (list, value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	sum_meeting (a_list: TRAVERSABLE [G]; value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- sum of `value' function across all items of `chain' meeting `condition'
		require
			valid_open_count: value.open_count = 1
			valid_value_function: first_item (a_list).is_valid_for (value)
		do
			if attached {LINEAR [G]} a_list as list then
				current_traversable := list; push_cursor
				Result := sum_linear (list, value, condition)
				pop_cursor
			else
				Result := sum_linear (a_list.linear_representation, value, condition)
			end
		end

feature -- Contract Support

	first_item (list: TRAVERSABLE [G]): EL_CONTAINER_ITEM [G]
		do
			create Result.make (list)
		end

feature {NONE} -- Implementation

	sum_linear (list: LINEAR [G]; value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- sum of `value' function across all items of `chain' meeting `condition'
		do
			from list.start until list.after loop
				if condition.met (list.item) then
					Result := Result + value (list.item)
				end
				list.forth
			end
		end

feature {NONE} -- Internal attributes

	current_traversable: TRAVERSABLE [G]

end