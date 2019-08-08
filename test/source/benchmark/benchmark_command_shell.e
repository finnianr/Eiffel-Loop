note
	description: "Command shell for various kinds of performance comparison benchmarks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-06 8:10:36 GMT (Tuesday 6th August 2019)"
	revision: "9"

class
	BENCHMARK_COMMAND_SHELL

inherit
	EL_BENCHMARK_COMMAND_SHELL
		export
			{EL_COMMAND_CLIENT} make
		end

create
	make

feature {NONE} -- Constants

	Factory: EL_OBJECT_FACTORY [EL_BENCHMARK_COMPARISON]
		once
			create Result.make_from_table (<<
				["Compare list iteration methods",					{LIST_ITERATION_COMPARISON}],
				["Compare hash-set vs linear search",				{HASH_SET_VERSUS_LINEAR_COMPARISON}],
				["Compare string concatenation methods",			{STRING_CONCATENATION_COMPARISON}],
				["Compare {ZSTRING}.replace_substring",			{REPLACE_SUBSTRING_COMPARISON}],
				["Compare {ZSTRING}.substring_index",				{SUBSTRING_INDEX_COMPARISON}],
				["Compare setting agent routine argument",		{SET_ROUTINE_ARGUMENT_COMPARISON}]
			>>)
		end

end
