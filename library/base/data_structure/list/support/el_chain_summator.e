note
	description: "[
		Functions to sum a numeric value function across each item in a chain of objects of type G
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
		local
			operands: TUPLE [G]; operands_set: BOOLEAN
		do
			chain.push_cursor
			from chain.start until chain.after loop
				if condition.met (chain.item) then
					if operands_set then
						operands.put (chain.item, 1)
					else
						operands := [chain.item]
						value.set_operands (operands)
						operands_set := True
					end
					value.apply
					Result := Result + value.last_result
				end
				chain.forth
			end
			chain.pop_cursor
		end

end
