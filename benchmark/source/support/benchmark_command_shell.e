note
	description: "Command shell for various kinds of performance comparison benchmarks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-13 15:19:57 GMT (Monday 13th March 2023)"
	revision: "34"

class
	BENCHMARK_COMMAND_SHELL

inherit
	EL_BENCHMARK_COMMAND_SHELL
		export
			{EL_COMMAND_CLIENT} make
		end

create
	make

feature -- Constants

	Description: STRING = "Menu driven benchmark comparison tests"

feature {NONE} -- Implementation

	new_benchmarks: TUPLE [
		ARRAYED_VS_LINKED_LIST,
		ARRAYED_VS_HASH_SET_SEARCH,
		ATTACH_TEST_VS_BOOLEAN_COMPARISON,

		BIT_POP_COUNT_COMPARISON,
		BIT_SHIFT_COUNT_COMPARISON,

		DIRECTORY_WALK_VS_FIND_COMMAND,
		HASH_TABLE_VS_NAMEABLES_LIST_SEARCH,

		LIST_ITERATION_COMPARISON,
		ROUTINE_CALL_ON_ONCE_VS_EXPANDED
	]
		do
			create Result
		end

end