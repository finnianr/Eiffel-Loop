note
	description: "[
		Compare repeated routine execution with and without caching of operand tuple.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-08 9:05:59 GMT (Thursday 8th April 2021)"
	revision: "4"

class
	SET_ROUTINE_ARGUMENT_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Basic operations

	execute
		local
			list: EL_ARRAYED_LIST [INTEGER_REF]
		do
			create list.make (1000)
			from until list.full loop
				list.extend ((list.count + 1).to_reference)
			end
			compare ("compare_list_iteration_methods", <<
				["Using routine applicator", agent do_sum (list, create {EL_CHAIN_SUMMATOR [INTEGER_REF, INTEGER]})],
				["Applying with value (item)", agent do_sum (list, create {INTEGER_REF_SUMMATOR})]
			>>)
		end

feature {NONE} -- Implementation

	do_sum (list: EL_ARRAYED_LIST [INTEGER_REF]; summator: EL_CHAIN_SUMMATOR [INTEGER_REF, INTEGER])
		local
			sum: INTEGER
		do
			sum := summator.sum (list, agent {INTEGER_REF}.item)
		end

end