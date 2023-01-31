note
	description: "Command shell for various kinds of performance comparison benchmarks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-31 9:44:08 GMT (Tuesday 31st January 2023)"
	revision: "26"

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
		APPEND_Z_CODE_VS_APPEND_CHARACTER,
		ARRAYED_VS_LINKED_LIST,
		ARRAYED_VS_HASH_SET_SEARCH,

		BIT_SHIFT_COUNT_COMPARISON,
		DIRECTORY_WALK_VS_FIND_COMMAND,
		HASH_TABLE_VS_NAMEABLES_LIST_SEARCH,
		MAKE_GENERAL_COMPARISON,

		THREE_LINE_STATE_COMPARISON_METHODS,
		THREE_WAYS_TO_CONCATENATE_STRINGS,

		SEVEN_LIST_ITERATION_METHODS,
		STRING_SPLIT_ITERATION_COMPARISON,
		STRING_ITEM_8_VS_ITEM,
		SUBSTRING_INDEX_COMPARISON,

		REPLACE_SUBSTRING_ALL_VS_GENERAL,
		ROUTINE_CALL_ON_ONCE_VS_EXPANDED,

		UNENCODED_CHARACTER_LIST_GENERATION,
		UNICODE_ITEM_COMPARISON,
		ZSTRING_SPLIT_COMPARISON
	]
		do
			create Result
		end

end


