note
	description: "[
		Compare key search speed of [$source HASH_TABLE] and [$source EL_NAMEABLES_LIST]
	]"
	notes: "[
		Performance is more or less identical in finalized executable

			SELECTED: Compare hash-table vs nameables-list search
			Benchmark: compare search with 23 items
			Getting average time: Hash (of 10 runs)
			Getting average time: Binary (of 10 runs)

			Average execution times (in ascending order)
			Hash   :  0.500 millisecs
			Binary :  0.500 millisecs

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	HASH_TABLE_VS_NAMEABLES_LIST_SEARCH

inherit
	EL_BENCHMARK_COMPARISON

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_REFLECTION_HANDLER

create
	make

feature -- Basic operations

	execute
		local
			parameters: FCGI_REQUEST_PARAMETERS
			nameables_list: EL_NAMEABLES_LIST [EL_REFLECTED_FIELD]
			field_table: EL_REFLECTED_FIELD_TABLE
		do
			create parameters.make
			field_table := parameters.field_table
			create nameables_list.make (field_table.linear_representation.to_array)

			compare ("compare search with " + field_table.count.out + " items", <<
				["Hash",	agent do_hash_search (field_table.current_keys, field_table)],
				["Binary",	agent do_binary_search (field_table.current_keys, nameables_list)]
			>>)
		end

feature {NONE} -- Implementation

	do_binary_search (field_names: ARRAY [STRING]; list: EL_NAMEABLES_LIST [EL_REFLECTED_FIELD])
		local
			i: INTEGER
		do
			from i := 1 until i > field_names.count loop
				list.search (field_names [i])
				i := i + 1
			end
		end

	do_hash_search (field_names: ARRAY [STRING]; field_table: EL_REFLECTED_FIELD_TABLE)
		local
			i: INTEGER
		do
			from i := 1 until i > field_names.count loop
				field_table.search (field_names [i])
				i := i + 1
			end
		end

end