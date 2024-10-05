note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "14"

class
	ARRAYED_VS_HASH_SET_SEARCH

inherit
	EL_BENCHMARK_COMPARISON

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature -- Access

	Description: STRING = "Hash-set vs linear search"

feature -- Basic operations

	execute
		local
			list: ARRAYED_SET [INTEGER]; hash_set: EL_HASH_SET [INTEGER]
			i, size: INTEGER
		do
			across << 10, 20, 200 >> as n loop
				size := n.item
				create list.make (size)
				create hash_set.make (size)
				from i := 1 until i > size loop
					list.extend (i); hash_set.put (i)
					i := i + 1
				end
				compare ("check if set of integers has: " + size.out, <<
					["EL_HASH_SET [INTEGER]",	agent do_search (hash_set)],
					["ARRAYED_SET [INTEGER]",	agent do_search (list)]
				>>)
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