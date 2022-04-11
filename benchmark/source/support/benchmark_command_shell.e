note
	description: "Command shell for various kinds of performance comparison benchmarks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-11 9:30:09 GMT (Monday 11th April 2022)"
	revision: "22"

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

	Description: STRING = "Menu driven benchmark tests"

feature {NONE} -- Constants

	Factory: EL_OBJECT_FACTORY [EL_BENCHMARK_COMPARISON]
		once
			create Result.make (<<
				["call on expanded vs once ref object",			{ROUTINE_CALL_ON_ONCE_VS_EXPANDED}],
				["filling linked VS arrayed list",					{ARRAYED_VS_LINKED_LIST}],
				["finding files with extension",						{DIRECTORY_WALK_VS_FIND_COMMAND}],
				["list iteration methods",								{SEVEN_LIST_ITERATION_METHODS}],
				["hash-set vs linear search",							{ARRAYED_VS_HASH_SET_SEARCH}],
				["hash-table vs nameables-list search",			{HASH_TABLE_VS_NAMEABLES_LIST_SEARCH}],
				["string concatenation methods",						{THREE_WAYS_TO_CONCATENATE_STRINGS}],
				["unencoded list generation",							{UNENCODED_CHARACTER_LIST_GENERATION}],

				["CSV parsing methods",									{THREE_LINE_STATE_COMPARISON_METHODS}],
				["STRING split iteration methods",					{STRING_SPLIT_ITERATION_COMPARISON}],

				["{L1_UC_STRING}.make_general",						{MAKE_GENERAL_COMPARISON}],
				["{L1_UC_STRING}.unicode",								{UNICODE_ITEM_COMPARISON}],
				["{ZSTRING}.append_zcode VS append_character",	{APPEND_Z_CODE_VS_APPEND_CHARACTER}],
				["{ZSTRING}.replace_substring",						{REPLACE_SUBSTRING_ALL_VS_GENERAL}],
				["{ZSTRING}.substring_index",							{SUBSTRING_INDEX_COMPARISON}],
				["{ZSTRING}.split_intervals",							{ZSTRING_SPLIT_COMPARISON}]
			>>)
		end

end








