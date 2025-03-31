note
	description: "Finalized executable tests for Eiffel-Loop base library [./#libraries_base base.ecf]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-31 8:44:02 GMT (Monday 31st March 2025)"
	revision: "201"

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
		GROUPED_TABLE_TEST_SET,
		HASH_SET_TEST_SET,
		HASH_TABLE_TEST_SET,
		PATH_TEST_SET,
		REFLECTION_TEST_SET,

		SE_ARRAY2_TEST_SET,
		SPLIT_STRING_TEST_SET,
		STRING_CONVERSION_TEST_SET,
		STRING_ITERATION_CURSOR_TEST_SET,
		STRING_LIST_TEST_SET,
		STRING_TEST_SET,
		SUBSTRING_32_ARRAY_TEST_SET,

		TEMPLATE_TEST_SET,
		TEXT_FILE_TEST_SET,
		TUPLE_TEST_SET,

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

feature {NONE} -- Compiled classes

	app_manage: TUPLE [
		EL_MAKEABLE_FROM_ZSTRING_OPERAND_SETTER
	]
		do
			create Result
		end

	data_structure: TUPLE [
		EL_AGENT_FACTORY_POOL [ANY],
		EL_ARRAYED_COMPACT_INTERVAL_LIST,

		EL_BORROWED_OBJECT_CURSOR [ANY],
		EL_BORROWED_OBJECT_SCOPE [ANY],

		EL_CALL_SEQUENCE [TUPLE],
		EL_CODE_VALUE_LIST [ANY],
		EL_CONFORMING_INSTANCE_TYPE_MAP [ANY],
		EL_CONFORMING_INSTANCE_TABLE [ANY],
		EL_COUNTER_TABLE [HASHABLE],

		EL_DEFERRED_CELL [ANY],
		EL_DISCARDING_ARRAYED_LIST [ANY],
		EL_IS_DELETED_CONDITION [EL_STORABLE],
		EL_ITERABLE_POOL_SCOPE [ANY],
		EL_KEY_INDEXED_ARRAYED_MAP_LIST [COMPARABLE, ANY],
		EL_NAMEABLES_LIST [EL_NAMEABLE [READABLE_STRING_GENERAL]],
		EL_QUERY_CONDITION_FACTORY [ANY],
		EL_OBJECTS_BY_TYPE,
		EL_POOL_SCOPE_CURSOR [ANY],
		EL_REPEATED_NUMERIC_LIST [NUMERIC],
		EL_SHARED_CELL [ANY],
		EL_SUBARRAY [ANY],
		EL_UNIQUE_ARRAYED_LIST [HASHABLE]
	]
		do
			create Result
		end

	date_time: TUPLE [
		EL_DATE, EL_DATEABLE,
		EL_QUANTITY_INCREASE_RATE_CALCULATOR
	]
		do
			create Result
		end

	initialization: TUPLE [
		EL_MAKEABLE_TO_SIZE_FACTORY [EL_MAKEABLE_TO_SIZE]
	]
		do
			create Result
		end

	io_: TUPLE [
		EL_AGENT_PROGRESS_DISPLAY,
		EL_COMMAND_SHELL,
		EL_CONSOLE,
		EL_LOG_HANDLER,
		EL_QUANTITY_PROGRESS_INFO,

		EL_STRING_8_IO_MEDIUM_LINE_SOURCE,
		EL_USER_MENU_SELECT,
		EL_ZSTRING_IO_MEDIUM_LINE_SOURCE
	]
		do
			create Result
		end

	kernel: TUPLE [
		EL_ARRAY_READER,
		EL_BINARY_CONVERTER,
		EL_CROSS_PLATFORM [EL_PLATFORM_IMPLEMENTATION],

		EL_DEFAULT_COMMAND,

		EL_EVENT_CHECKER, EL_EVENT_LISTENER_PAIR,
		EL_EXTERNAL_LIBRARY [EL_INITIALIZEABLE],

		EL_FUNCTION_ID,

		EL_ITERABLE_SCOPE [ANY],
		EL_ITERATION_OUTPUT,
		EL_INTEGER_32_BIT_ROUTINES,

		EL_NATURAL_8_BIT_ROUTINES,

		EL_OCTAL_CONVERTER,

		EL_PRECURSOR_MAP_16, EL_PRECURSOR_MAP_64,
		EL_PREDICATE,

		EL_SHARED_INITIALIZER [EL_INITIALIZEABLE],
		EL_TUPLE_FACTORY [ANY, ANY, TUPLE]
	]
		do
			create Result
		end

	math: TUPLE [
		EL_COLUMN_VECTOR_DOUBLE,
		EL_COMPLEX_COLUMN_VECTOR [NUMERIC],
		EL_DOUBLE_COMPARISON,

		EL_GRAPH_POINT,
		EL_GRAPH_REAL_SCALE,
		EL_GRAPH_SCALE,
		EL_GRID_COORDINATE,

		EL_INTEGER_COORDINATE,
		EL_INTEGER_POINT,
		EL_INTERVAL_POSITION [NUMERIC],

		EL_LINE_SEGMENT_SELECTION,
		EL_NATURAL_32_COUNTER,
		EL_REAL_INTERVAL_POSITION
	]
		do
			create Result
		end

	persistency: TUPLE [
		EL_ARRAY_WRITER [NUMERIC],
		EL_ARRAY_WRITER_DOUBLE,
		EL_INTEGER_VARIABLE_TABLE,
		EL_DOUBLE_VARIABLE_TABLE
	]
		do
			create Result
		end

	reflection: TUPLE [
		EL_DATE_TIME_REPRESENTATION, EL_ENUMERATION_VALUE [NUMERIC],
		EL_REFLECTED_TIME, EL_REFLECTIVE_BOOLEAN_REF
	]
		do
			create Result
		end

	runtime: TUPLE [
		EL_ASTRING_READER,
		EL_ENVIRON_VARIABLE,

		EL_MEMORY_ARRAY [ANY],
		EL_MEMORY_CHARACTER_ARRAY,
		EL_MEMORY_DOUBLE_ARRAY,
		EL_MEMORY_INTEGER_16_ARRAY,
		EL_MODULE_MEMORY,

		EL_MUTEX_NUMERIC [INTEGER],
		EL_MUTEX_VALUE [BOOLEAN],
		EL_MUTEX_CREATEABLE_REFERENCE [ANY],

		EL_TIMEOUT_THREAD, EL_TIME,

		EL_STD_MUTEX_HASH_TABLE [ANY, HASHABLE],
		EL_SYSTEM_TIMER
	]
		do
			create Result
		end

	string_32: TUPLE [
		EL_IMMUTABLE_STRING_32_TABLE,
		EL_STRING_32_BUFFER_ROUTINES,
		EL_STRING_32_EDITOR,
		EL_STRING_32_TABLE [ANY],
		EL_STRING_32_SPLIT_INTERVALS,
		EL_STYLED_STRING_32_LIST,
		EL_SUBSTRING_32,
		EL_URI_QUERY_STRING_32_HASH_TABLE
	]
		do
			create Result
		end

	string_8: TUPLE [
		EL_IMMUTABLE_STRING_8_GRID,
		EL_STYLED_STRING_8_LIST,
		EL_STRING_8_UNESCAPER,
		EL_STRING_8_EDITOR,
		EL_STRING_8_SPLIT_INTERVALS,
		EL_URI_QUERY_STRING_8_HASH_TABLE
	]
		do
			create Result
		end

	string_structures: TUPLE [
		EL_STRING_GENERAL_TABLE [ANY],
		EL_TABLE_INTERVAL_MAP_LIST
	]
		do
			create Result
		end

	testing: TUPLE [
		EL_CRC_32_CONSOLE_ONLY_LOG
	]
		do
			create Result
		end

	text: TUPLE [
		EL_ASSIGNMENT_ROUTINES,
		EL_CACHED_STRING [READABLE_STRING_GENERAL],
		EL_CHARACTER_32, EL_CHARACTER_8,
		EL_CASE_COMPARISON,

		EL_DESCRIBABLE,

		EL_ITERABLE_SPLIT_FACTORY_ROUTINES,

		EL_LOCALIZEABLE, EL_LOCALIZED,

		EL_MAKEABLE_FROM_STRING [STRING_GENERAL],
		EL_MODULE_UTF_8,

		EL_SHARED_SYMBOL, EL_STRING_GENERAL_ROUTINES
	]
		do
			create Result
		end

	zstring: TUPLE [
		EL_LINKED_STRING_LIST [STRING_GENERAL],
		EL_STYLED_ZSTRING_LIST,
		EL_ZSUBSTRING
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

		**TEST SETS**

			${ARRAYED_LIST_TEST_SET},
			${BASE_POWER_2_CONVERTER_TEST_SET},
			${BIT_ROUTINE_TEST_SET},
			${CHARACTER_TEST_SET},
			${CONTAINER_STRUCTURE_TEST_SET},
			${DATA_DIGESTS_TEST_SET},
			${DATE_TIME_TEST_SET},
			${EIFFEL_NAME_TRANSLATEABLE_TEST_SET},
			${GENERAL_TEST_SET},
			${GROUPED_TABLE_TEST_SET},
			${HASH_SET_TEST_SET},
			${HASH_TABLE_TEST_SET},
			${PATH_TEST_SET},
			${REFLECTION_TEST_SET},
			${SE_ARRAY2_TEST_SET},
			${SPLIT_STRING_TEST_SET},
			${STRING_CONVERSION_TEST_SET},
			${STRING_ITERATION_CURSOR_TEST_SET},
			${STRING_LIST_TEST_SET},
			${STRING_TEST_SET},
			${SUBSTRING_32_ARRAY_TEST_SET},
			${TEMPLATE_TEST_SET},
			${TEXT_FILE_TEST_SET},
			${TUPLE_TEST_SET},
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