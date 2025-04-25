note
	description: "Object memory footprint related benchmark comparisons"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-25 12:44:28 GMT (Friday 25th April 2025)"
	revision: "1"

class
	MEMORY_BENCHMARK_SHELL

inherit
	EL_BENCHMARK_COMMAND_SHELL
		export
			{EL_COMMAND_CLIENT} make
		redefine
			is_performance
		end

create
	make

feature -- Constants

	Description: STRING = "Object memory footprint related benchmarks"

feature -- Status query

	is_performance: BOOLEAN = False

feature {NONE} -- Implementation

	new_benchmarks: TUPLE [
		COMPARE_CODE_STRING_WITH_INTEGER_64,
		ENUMERATION_MEMORY_COMPARISON,
		STRING_HASH_TABLE_MEMORY_COMPARISON
	]
		do
			create Result
		end

end