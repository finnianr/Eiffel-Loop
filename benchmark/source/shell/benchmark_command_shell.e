note
	description: "Command shell for various kinds of performance comparison benchmarks"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-12 10:11:06 GMT (Wednesday 12th November 2025)"
	revision: "42"

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

		CLASS_ID_ENUM_VS_TYPE_OBJECT,
		COMPACTABLE_REFLECTIVE_VS_MANUAL_BIT_MASK,

		DEVELOPER_COMPARISON,
		DIRECTORY_WALK_VS_FIND_COMMAND,
		HASH_TABLE_VS_NAMEABLES_LIST_SEARCH,

		LIST_ITERATION_COMPARISON,
		P_I_TH_LOWER_UPPER_VS_INLINE_CODE,
		REFLECTED_REFERENCE_VS_OPTIMIZED_FIELD_RW,
		ROUTINE_CALL_ON_ONCE_VS_EXPANDED,
		STRING_TABLE_VS_HASH_SET_SEARCH,
		SYSTEM_TIME_COMPARISON,
		TOKENIZED_STEPS_VS_XPATH_STRING
	]
		do
			create Result
		end

end