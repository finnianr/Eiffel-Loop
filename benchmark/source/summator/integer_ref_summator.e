note
	description: "Summator without reusing routine operand"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-15 14:53:33 GMT (Thursday 15th November 2018)"
	revision: "1"

class
	INTEGER_REF_SUMMATOR

inherit
	EL_CHAIN_SUMMATOR [INTEGER_REF, INTEGER]
		redefine
			sum_meeting
		end

feature -- Access

	sum_meeting (
		chain: EL_CHAIN [INTEGER_REF]; value: FUNCTION [INTEGER_REF, INTEGER]
		condition: EL_QUERY_CONDITION [INTEGER_REF]): INTEGER
		-- sum of `value' function across all items of `chain' meeting `condition'
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
