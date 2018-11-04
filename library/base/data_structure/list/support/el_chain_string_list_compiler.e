note
	description: "Compiles list of strings using value function for item chain"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_CHAIN_STRING_LIST_COMPILER [G, S -> STRING_GENERAL create make, make_empty end]

feature -- Access

	list (chain: EL_CHAIN [G]; value: FUNCTION [G, S]): EL_STRING_LIST [S]
		-- sum of `value' function across all items of `chain'
		do
			Result := list_meeting (chain, value, create {EL_ANY_QUERY_CONDITION [G]})
		end

	list_meeting (chain: EL_CHAIN [G]; value: FUNCTION [G, S]; condition: EL_QUERY_CONDITION [G]): EL_STRING_LIST [S]
		-- sum of `value' function across all items of `chain' meeting `condition'
		require
			valid_open_count: value.open_count = 1
			valid_value_function: not chain.is_empty implies value.valid_operands ([chain.first])
		local
			operands: TUPLE [G]
		do
			if attached {EL_ANY_QUERY_CONDITION [G]} condition then
				create Result.make (chain.count)
			else
				create Result.make (chain.count_meeting (condition))
			end
			if Result.capacity > 0 then
				operands := [chain.first]
				value.set_operands (operands)
				chain.push_cursor
				from chain.start until chain.after loop
					if condition.met (chain.item) then
						operands.put (chain.item, 1)
						value.apply
						Result.extend (value.last_result)
					end
					chain.forth
				end
				chain.pop_cursor
			end
		end


end
