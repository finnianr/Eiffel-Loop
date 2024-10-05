note

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "13"

class
	HASH_TABLE_VS_NAMEABLES_LIST_SEARCH

inherit
	EL_BENCHMARK_COMPARISON

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_REFLECTION_HANDLER

create
	make

feature -- Access

	Description: STRING = "Hash-table vs nameables-list search"

feature -- Basic operations

	execute
		local
			parameters: FCGI_REQUEST_PARAMETERS; field_table: EL_FIELD_TABLE
			nameables_list: EL_NAMEABLES_LIST [EL_REFLECTED_FIELD]
		do
			create parameters.make
			field_table := parameters.field_table
			create nameables_list.make (field_table.item_list.to_array)

			compare ("compare search with " + field_table.count.out + " items", <<
				["Hash",	agent do_hash_search (field_table.current_keys, field_table)],
				["Binary",	agent do_binary_search (field_table.current_keys, nameables_list)]
			>>)
		end

feature {NONE} -- Implementation

	do_binary_search (field_names: ARRAY [IMMUTABLE_STRING_8]; list: EL_NAMEABLES_LIST [EL_REFLECTED_FIELD])
		local
			i: INTEGER
		do
			from i := 1 until i > field_names.count loop
				list.search (field_names [i])
				i := i + 1
			end
		end

	do_hash_search (field_names: ARRAY [IMMUTABLE_STRING_8]; field_table: EL_FIELD_TABLE)
		local
			i: INTEGER
		do
			from i := 1 until i > field_names.count loop
				field_table.search (field_names [i])
				i := i + 1
			end
		end

end