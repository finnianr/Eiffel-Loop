note
	description: "Finalized executable tests for Eiffel-Loop base library [./#libraries_base base.ecf]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 11:26:15 GMT (Thursday 5th January 2023)"
	revision: "159"

class
	BASE_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		ARRAYED_LIST_TEST_SET,
		CONTAINER_STRUCTURE_TEST_SET,
		DATA_DIGESTS_TEST_SET,
		DATE_TIME_TEST_SET,
		TEXT_TEST_SET,

		GENERAL_TEST_SET,
		HASH_TABLE_TEST_SET,
		L1_UC_STRING_TEST,
		PATH_TEST_SET,
		BASE_POWER_2_CONVERTER_TEST_SET,

		REFLECTION_TEST_SET,

		SE_ARRAY2_TEST_SET,
		SEQUENTIAL_INTERVALS_TEST_SET,
		SPLIT_STRING_TEST_SET,
		STRING_ITERATION_CURSOR_TEST_SET,
		STRING_32_ROUTINES_TEST_SET,
		SUBSTRING_32_ARRAY_TEST_SET,

		TEMPLATE_TEST_SET,

		URI_TEST_SET,
		UTF_CONVERTER_TEST_SET,

		ZSTRING_EDITOR_TEST_SET,
		ZSTRING_TEST_SET,
		ZSTRING_TOKEN_TABLE_TEST_SET
	]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Compile classes

	text: TUPLE [
		EL_CACHED_STRING [READABLE_STRING_GENERAL],

		EL_ESCAPED_STRING_FIELD_VALUE_TABLE [STRING_GENERAL],

		EL_LINKED_STRING_LIST [STRING_GENERAL],
		EL_IMMUTABLE_STRING_8_SPLIT_LIST, EL_IMMUTABLE_STRING_32_SPLIT_LIST,

		EL_MAKEABLE_FROM_STRING [STRING_GENERAL],
		EL_MAKEABLE_FROM_ZSTRING_OPERAND_SETTER,

		EL_STYLED_STRING_8_LIST, EL_STYLED_STRING_32_LIST, EL_STYLED_ZSTRING_LIST,
		EL_STRING_8_UNESCAPER,
		EL_STRING_8_EDITOR, EL_STRING_32_EDITOR,
		EL_STRING_8_IO_MEDIUM_LINE_SOURCE,

		EL_URI_QUERY_STRING_8_HASH_TABLE, EL_URI_QUERY_STRING_32_HASH_TABLE
	]
		do
			create Result
		end

	compile: TUPLE [
		EL_ARRAY_READER,
		EL_BINARY_CONVERTER,

		EL_CRC_32_CONSOLE_ONLY_LOG,

		EL_DATE_TIME_REPRESENTATION, EL_DATE,
		EL_DOCUMENT_NODE_STRING,
		EL_EXTERNAL_LIBRARY [EL_INITIALIZEABLE],

		EL_INTEGER_FIELD_VALUE_TABLE,
		EL_INTEGER_32_BIT_ROUTINES,

		EL_MUTEX_NUMERIC [INTEGER],
		EL_MUTEX_VALUE [BOOLEAN],

		EL_OCTAL_CONVERTER,

		EL_SHARED_INITIALIZER [EL_INITIALIZEABLE],

		EL_REFLECTED_TIME,

		EL_TIMEOUT_THREAD, EL_TIME

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

			[$source ARRAYED_LIST_TEST_SET]
			[$source CHAIN_TEST_SET]
			[$source DATA_DIGESTS_TEST_SET]
			[$source DATE_TIME_TEST_SET]
			[$source ESCAPED_TEXT_TEST_SET]

			[$source GENERAL_TEST_SET]
			[$source HASH_TABLE_TEST_SET]
			[$source L1_UC_STRING_TEST]

			[$source PATH_TEST_SET]
			[$source PATH_STEPS_TEST_SET]

			[$source REFLECTION_TEST_SET]

			[$source SE_ARRAY2_TEST_SET]
			[$source SEQUENTIAL_INTERVALS_TEST_SET]
			[$source SPLIT_STRING_TEST_SET]
			[$source STRING_EDITION_HISTORY_TEST_SET]
			[$source STRING_32_ROUTINES_TEST_SET]
			[$source STRING_ITERATION_CURSOR_TEST_SET]
			[$source SUBSTRING_32_ARRAY_TEST_SET]
			[$source SUBSTITUTION_TEMPLATE_TEST_SET]

			[$source TEMPLATE_TEST_SET]

			[$source URI_TEST_SET]
			[$source UTF_CONVERTER_TEST_SET]

			[$source ZSTRING_EDITOR_TEST_SET]
			[$source ZSTRING_TEST_SET]
			[$source ZSTRING_TOKEN_TABLE_TEST_SET]
	]"
end