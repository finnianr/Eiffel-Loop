note
	description: "[
		Question: at what point does a linear search of an INTEGER array stop being faster than a hash set?
		
		Answer: count > 10
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-04 15:54:17 GMT (Sunday 4th April 2021)"
	revision: "3"

class
	HASH_SET_VERSUS_LINEAR_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature -- Basic operations

	execute
		local
			list: ARRAYED_SET [INTEGER]; hash_set: EL_HASH_SET [INTEGER]
			comparison_list: EL_ARRAYED_MAP_LIST [READABLE_STRING_GENERAL, ROUTINE]
			i, size: INTEGER
		do
			create comparison_list.make (10)
			from size := 10 until size > 100 loop
				create list.make (size)
				create hash_set.make (size)
				from i := 1 until i > size loop
					list.extend (i); hash_set.put (i)
					i := i + 1
				end
				comparison_list.extend ("EL_HASH_SET [INTEGER] size=" + size.out, agent do_search (hash_set))
				comparison_list.extend ("ARRAYED_SET [INTEGER] size=" + size.out, agent do_search (list))
				size := size * 10
			end
			compare ("compare INTEGER set searchs", comparison_list.to_array)
		end

feature {NONE} -- Implementation

	do_search (set: SET [INTEGER])
		local
			i: INTEGER
		do
			from i := 0 until i > 1000 loop
				if set.has (i \\ set.count + 1) then
				end
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Iteration_count: INTEGER
		once
			Result := new_iteration_count (1000)
		end

end