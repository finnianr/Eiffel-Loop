note
	description: "[
		Question: at what point does a linear search of an INTEGER array stop being faster than a hash set?
		
		Answer: count > 10
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	ARRAYED_VS_HASH_SET_SEARCH

inherit
	EL_BENCHMARK_COMPARISON

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature -- Basic operations

	execute
		local
			list: ARRAYED_SET [INTEGER]; hash_set: EL_HASH_SET [INTEGER]
			i, size: INTEGER
		do
			from size := 10 until size > 500 loop
				create list.make (size)
				create hash_set.make (size)
				from i := 1 until i > size loop
					list.extend (i); hash_set.put (i)
					i := i + 1
				end
				compare ("compare INTEGER set searchs for size=" + size.out, <<
					["EL_HASH_SET [INTEGER]",	agent do_search (hash_set)],
					["ARRAYED_SET [INTEGER]",	agent do_search (list)]
				>>)
				size := size * 50
			end
		end

feature {NONE} -- Implementation

	do_search (set: SET [INTEGER])
		local
			i: INTEGER
		do
			from i := 1 until i > set.count loop
				if set.has (i) then
				end
				i := i + 1
			end
		end

end