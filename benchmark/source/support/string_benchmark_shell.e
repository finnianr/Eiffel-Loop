note
	description: "String related benchmark comparisons"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-24 7:43:32 GMT (Thursday 24th August 2023)"
	revision: "35"

class
	STRING_BENCHMARK_SHELL

inherit
	EL_BENCHMARK_COMMAND_SHELL
		export
			{EL_COMMAND_CLIENT} make
		end

create
	make

feature -- Constants

	Description: STRING = "String related benchmark comparisons"

feature {NONE} -- Implementation

	new_benchmarks: TUPLE [
		APPEND_Z_CODE_VS_APPEND_CHARACTER,
		ARRAYED_INTERVAL_LIST_COMPARISON,
		ATTACH_TEST_VS_BOOLEAN_COMPARISON,

		IMMUTABLE_STRING_SPLIT_COMPARISON,
		LINE_STATE_MACHINE_COMPARISON,

		MAKE_GENERAL_COMPARISON,

		STRING_CONCATENATION_COMPARISON,
		STRING_SPLIT_ITERATION_COMPARISON,
		STRING_ITEM_8_VS_ITEM,
		SUBSTRING_INDEX_COMPARISON,

		REPLACE_SUBSTRING_ALL_VS_GENERAL,

		UNENCODED_CHARACTER_ITERATION_COMPARISON,
		UNENCODED_CHARACTER_LIST_GENERATION,
		UNICODE_ITEM_COMPARISON,

		ZSTRING_INTERVAL_SEARCH_COMPARISON,
		ZSTRING_SAME_CHARACTERS_COMPARISON,
		ZSTRING_SPLIT_COMPARISON,
		ZSTRING_SPLIT_LIST_COMPARISON
	]
		do
			create Result
		end

end