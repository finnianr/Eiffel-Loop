note
	description: "Test for [$source EL_BENCHMARK_COMMAND_SHELL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-15 14:17:34 GMT (Thursday 15th November 2018)"
	revision: "7"

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
				["Compare list iteration methods",				{LIST_ITERATION_COMPARISON}],
				["Compare string concatenation methods",		{STRING_CONCATENATION_COMPARISON}],
				["Compare {ZSTRING}.replace_substring",		{REPLACE_SUBSTRING_COMPARISON}],
				["Compare {ZSTRING}.substring_index",			{SUBSTRING_INDEX_COMPARISON}],
				["Compare setting agent routine argument",	{SET_ROUTINE_ARGUMENT_COMPARISON}]
			>>)
		end

end
