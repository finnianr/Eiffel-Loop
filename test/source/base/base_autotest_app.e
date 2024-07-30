note
	description: "Finalized executable tests for Eiffel-Loop base library [./#libraries_base base.ecf]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-30 12:11:30 GMT (Tuesday 30th July 2024)"
	revision: "187"

class
	BASE_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		ARRAYED_LIST_TEST_SET,

		BASE_POWER_2_CONVERTER_TEST_SET,
		BIT_ROUTINE_TEST_SET,

		CHARACTER_TEST_SET,
		CONTAINER_STRUCTURE_TEST_SET,

		DATA_DIGESTS_TEST_SET,
		DATE_TIME_TEST_SET,

		EIFFEL_NAME_TRANSLATEABLE_TEST_SET,
		GENERAL_TEST_SET,
		HASH_TABLE_TEST_SET,
		PATH_TEST_SET,
		REFLECTION_TEST_SET,

		SE_ARRAY2_TEST_SET,
		SPLIT_STRING_TEST_SET,
		STRING_CONVERSION_TEST_SET,
		STRING_ITERATION_CURSOR_TEST_SET,
		STRING_TEST_SET,
		SUBSTRING_32_ARRAY_TEST_SET,

		TEMPLATE_TEST_SET,

		URI_TEST_SET,
		UTF_CONVERTER_TEST_SET,

		ZSTRING_EDITOR_TEST_SET,
		ZSTRING_TEST_SET,
		ZSTRING_COMPARABLE_TEST_SET,
		ZSTRING_CONCATENATION_TEST_SET,
		ZSTRING_CONVERTABLE_TEST_SET,
		ZSTRING_TOKEN_TABLE_TEST_SET,
		ZSTRING_TRANSFORMABLE_TEST_SET
	]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Compile classes

	text: TUPLE [
		EL_STRING_32_BUFFER_ROUTINES,
		EL_CACHED_STRING [READABLE_STRING_GENERAL],
		EL_CHARACTER_32, EL_CHARACTER_8,
		EL_CASE_COMPARISON,

		EL_IMMUTABLE_STRING_8_GRID,
		EL_IMMUTABLE_STRING_32_TABLE,
		EL_ITERABLE_SPLIT_FACTORY_ROUTINES,
		EL_LINKED_STRING_LIST [STRING_GENERAL],

		EL_MAKEABLE_FROM_STRING [STRING_GENERAL],
		EL_MAKEABLE_FROM_ZSTRING_OPERAND_SETTER,

		EL_STYLED_STRING_8_LIST, EL_STYLED_STRING_32_LIST, EL_STYLED_ZSTRING_LIST,
		EL_STRING_8_UNESCAPER,
		EL_STRING_8_EDITOR, EL_STRING_32_EDITOR,
		EL_STRING_8_IO_MEDIUM_LINE_SOURCE,
		EL_STRING_32_TABLE [ANY], EL_STRING_GENERAL_TABLE [ANY],
		EL_STRING_32_SPLIT_INTERVALS, EL_STRING_8_SPLIT_INTERVALS,

		EL_URI_QUERY_STRING_8_HASH_TABLE, EL_URI_QUERY_STRING_32_HASH_TABLE
	]
		do
			create Result
		end

	compile: TUPLE [
		EL_ARRAY_READER,
		EL_BINARY_CONVERTER,

		EL_CRC_32_CONSOLE_ONLY_LOG,
		EL_CROSS_PLATFORM [EL_PLATFORM_IMPLEMENTATION],

		EL_DATE_TIME_REPRESENTATION, EL_DATE, EL_DATEABLE,
		EL_DOCUMENT_NODE_STRING,

		EL_EVENT_CHECKER, EL_EVENT_LISTENER_PAIR,
		EL_EXTERNAL_LIBRARY [EL_INITIALIZEABLE],

		EL_INTEGER_32_BIT_ROUTINES, EL_NATURAL_8_BIT_ROUTINES,
		EL_IS_DELETED_CONDITION [EL_STORABLE],

		EL_OCTAL_CONVERTER,
		EL_PRECURSOR_MAP_16, EL_PRECURSOR_MAP_64,
		EL_SHARED_INITIALIZER [EL_INITIALIZEABLE],
		EL_QUANTITY_INCREASE_RATE_CALCULATOR,
		EL_REFLECTED_TIME,
		EL_TUPLE_FACTORY [ANY, ANY, TUPLE]
	]
		do
			create Result
		end

	structures: TUPLE [
		EL_ARRAYED_COMPACT_INTERVAL_LIST,
		EL_BORROWED_OBJECT_CURSOR [ANY],

		EL_CALL_SEQUENCE [TUPLE],
		EL_CODE_VALUE_LIST [ANY],
		EL_CONFORMING_INSTANCE_TYPE_MAP [ANY],
		EL_CONFORMING_INSTANCE_TABLE [ANY],
		EL_COUNTER_TABLE [HASHABLE],

		EL_DEFERRED_CELL [ANY],
		EL_DISCARDING_ARRAYED_LIST [ANY],
		EL_HASHABLE_KEY_ARRAYED_MAP_LIST [HASHABLE, ANY],
		EL_ITERABLE_POOL_SCOPE [ANY],
		EL_KEY_INDEXED_ARRAYED_MAP_LIST [COMPARABLE, ANY],
		EL_NAMEABLES_LIST [EL_NAMEABLE [READABLE_STRING_GENERAL]],
		EL_QUERY_CONDITION_FACTORY [ANY],
		EL_OBJECTS_BY_TYPE,
		EL_POOL_SCOPE_CURSOR [ANY],
		EL_REPEATED_NUMERIC_LIST [NUMERIC],
		EL_SAVED_CURSOR [ANY],
		EL_SHARED_CELL [ANY],
		EL_SUBARRAY [ANY],
		EL_UNIQUE_ARRAYED_LIST [HASHABLE]
	]
		do
			create Result
		end

	runtime: TUPLE [
		EL_ENVIRON_VARIABLE,
		EL_TIMEOUT_THREAD, EL_TIME, EL_SYSTEM_TIMER,
		EL_MUTEX_NUMERIC [INTEGER], EL_MUTEX_VALUE [BOOLEAN]

	]
		do
			create Result
		end

feature {NONE} -- Implementation

	visible_types: TUPLE [SPLIT_STRING_TEST_SET, EL_GVFS_OS_COMMAND]
		do
			create Result
		end

note
	notes: "[
		Command option: `-base_autotest'

		**Test Sets**

			${ARRAYED_LIST_TEST_SET},
			${BASE_POWER_2_CONVERTER_TEST_SET},
			${BIT_ROUTINE_TEST_SET},
			${CHARACTER_TEST_SET},
			${CONTAINER_STRUCTURE_TEST_SET},
			${DATA_DIGESTS_TEST_SET},
			${DATE_TIME_TEST_SET},
			${EIFFEL_NAME_TRANSLATEABLE_TEST_SET},
			${GENERAL_TEST_SET},
			${HASH_TABLE_TEST_SET},
			${PATH_TEST_SET},
			${REFLECTION_TEST_SET},
			${SE_ARRAY2_TEST_SET},
			${SPLIT_STRING_TEST_SET},
			${STRING_CONVERSION_TEST_SET},
			${STRING_ITERATION_CURSOR_TEST_SET},
			${STRING_TEST_SET},
			${SUBSTRING_32_ARRAY_TEST_SET},
			${TEMPLATE_TEST_SET},
			${URI_TEST_SET},
			${UTF_CONVERTER_TEST_SET},
			${ZSTRING_EDITOR_TEST_SET},
			${ZSTRING_TEST_SET},
			${ZSTRING_COMPARABLE_TEST_SET},
			${ZSTRING_CONCATENATION_TEST_SET},
			${ZSTRING_CONVERTABLE_TEST_SET},
			${ZSTRING_TOKEN_TABLE_TEST_SET},
			${ZSTRING_TRANSFORMABLE_TEST_SET}

	]"
end