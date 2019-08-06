note
	description: "[
		Question: at what point does a linear search of an INTEGER array stop being faster than a hash set?
		
		Answer: count > 10
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
			list: ARRAYED_SET [INTEGER]; i, size, capacity: INTEGER
			hash_set: EL_HASH_SET [INTEGER]
		do
			from capacity := 10 until capacity > 20 loop
				size := capacity
				create list.make (size)
				create hash_set.make (size)
				lio.put_integer_field ("Initializing for size", size)
				lio.put_new_line
				from i := 1 until i > size loop
					list.extend (i); hash_set.put (i)
					i := i + 1
				end
				lio.put_line ("Running benchmarks..")
				compare ("compare search with " + size.out + " numbers", <<
					["Hashset",	agent do_search (hash_set)],
					["Linear",	agent do_search (list)]
				>>)
				capacity := capacity + 1
			end
		end

feature {NONE} -- Implementation

	do_search (set: SET [INTEGER])
		local
			random: RANDOM; target: INTEGER
		do
			create random.make
			from until random.index > Iteration_count loop
				target := random.item \\ set.count
				if set.has (target) then
				end
				random.forth
			end
		end

feature {NONE} -- Constants

	Iteration_count: INTEGER
		once
			Result := new_iteration_count (1000)
		end

end
