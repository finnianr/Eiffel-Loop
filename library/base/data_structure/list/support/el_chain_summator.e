note
	description: "[
		Functions to sum a numeric value function across each item in a chain of objects of type G.
		The supplied function agent must return a value conforming to type
		[https://www.eiffel.org/files/doc/static/18.01/libraries/base/numeric_links.html NUMERIC].
	]"
	tests: "Class [$source CHAIN_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 13:16:17 GMT (Friday   4th   October   2019)"
	revision: "7"

class
	EL_CHAIN_SUMMATOR [G, N -> NUMERIC]

feature -- Access

	sum (chain: EL_CHAIN [G]; value: FUNCTION [G, N]): N
		-- sum of `value' function across all items of `chain'
		do
			Result := sum_meeting (chain, value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	sum_meeting (chain: EL_CHAIN [G]; value: FUNCTION [G, N]; condition: EL_QUERY_CONDITION [G]): N
		-- sum of `value' function across all items of `chain' meeting `condition'
		require
			valid_open_count: value.open_count = 1
			valid_value_function: not chain.is_empty implies value.valid_operands ([chain.first])
		do
			chain.push_cursor
			from chain.start until chain.after loop
				if condition.met (chain.item) then
					Result := Result + value (chain.item)
				end
				chain.forth
			end
			chain.pop_cursor
		end

end
