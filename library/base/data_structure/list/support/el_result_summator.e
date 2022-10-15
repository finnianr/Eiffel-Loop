note
	description: "[
		Object to add together the [$source NUMERIC] results of a function applied to a
		[$source CONTAINER [G]] list of items filtered by an optional query condition
		[$source EL_QUERY_CONDITION [G]].
	]"
	tests: "Class [$source CHAIN_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-15 5:47:18 GMT (Saturday 15th October 2022)"
	revision: "11"

class
	EL_RESULT_SUMMATOR [G, N -> NUMERIC]

inherit
	EL_CONTAINER_STRUCTURE [G]
		export
			{NONE} all
		end

feature -- Access

	sum (container: CONTAINER [G]; value: FUNCTION [G, N]): N
		-- sum of `value' function across all items of `chain'
		do
			Result := sum_meeting (container, value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	sum_meeting (container: CONTAINER [G]; value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- sum of `value' function across all items of `chain' meeting `condition'
		require
			valid_value_function: first_item (container).is_valid_for (value)
		do
			if attached {LINEAR [G]} container as list then
				current_container := list; push_cursor
				Result := sum_linear (list, value, condition)
				pop_cursor
			elseif attached {ITERABLE [G]} container as iterable_list then
				across iterable_list as list loop
					if condition.met (list.item) then
						Result := Result + value (list.item)
					end
				end
			else
				Result := sum_linear (container.linear_representation, value, condition)
			end
		end

feature -- Contract Support

	first_item (container: CONTAINER [G]): EL_CONTAINER_ITEM [G]
		do
			create Result.make (container)
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

	current_container: CONTAINER [G]

end