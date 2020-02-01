note
	description: "[
		Compare repeated routine execution with and without caching of operand tuple.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 17:27:43 GMT (Saturday 1st February 2020)"
	revision: "2"

class
	SET_ROUTINE_ARGUMENT_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Basic operations

	execute
		local
			list: like new_integer_list
		do
			list := new_integer_list
			compare ("compare_list_iteration_methods", <<
				["Using routine applicator", agent do_sum (list, create {EL_CHAIN_SUMMATOR [INTEGER_REF, INTEGER]})],
				["Applying with value (item)", agent do_sum (list, create {INTEGER_REF_SUMMATOR})]
			>>)
		end

feature {NONE} -- Implementation

	do_sum (list: like new_integer_list; summator: EL_CHAIN_SUMMATOR [INTEGER_REF, INTEGER])
		local
			sum: INTEGER
		do
			sum := summator.sum (list, agent {INTEGER_REF}.item)
		end

	new_integer_list: EL_ARRAYED_LIST [INTEGER_REF]
		do
			create Result.make(Iteration_count)
			from  until Result.full loop
				Result.extend ((Result.count + 1).to_reference)
			end
		end

feature {NONE} -- Constants

	Iteration_count: INTEGER
		once
			Result := new_iteration_count (100_000)
		end
end
