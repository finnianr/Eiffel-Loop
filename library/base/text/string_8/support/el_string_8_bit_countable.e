note
	description: "[
		${EL_STRING_BIT_COUNTABLE} applicable to generic class taking a string parameter conforming
		to ${READABLE_STRING_8}
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:53 GMT (Tuesday 18th March 2025)"
	revision: "5"

deferred class
	EL_STRING_8_BIT_COUNTABLE [S -> READABLE_STRING_8]

inherit
	EL_STRING_BIT_COUNTABLE [S]
		undefine
			bit_count
		end

	EL_8_BIT_IMPLEMENTATION

note
	descendants: "[
			EL_STRING_8_BIT_COUNTABLE* [S -> ${READABLE_STRING_8}]
				${EL_IMMUTABLE_STRING_8_GRID}
				${EL_IMMUTABLE_STRING_8_TABLE}
					${EL_IMMUTABLE_UTF_8_TABLE}
					${EL_TUPLE_FIELD_TABLE}
				${EL_SPLIT_STRING_8_LIST}
				${EL_IMMUTABLE_8_MANAGER}
				${EL_STRING_8_ESCAPER_IMP}
					${XML_STRING_8_ESCAPER_IMP}
					${EL_CSV_STRING_8_ESCAPER_IMP}
				${EL_BORROWED_STRING_8_CURSOR}
				${EL_STRING_8_BUFFER_I*}
					${EL_STRING_8_BUFFER_ROUTINES}
					${EL_STRING_8_BUFFER}
				${EL_STRING_8_READER_WRITER}
				${EL_STRING_8_OCCURRENCE_INTERVALS}
					${EL_STRING_8_SPLIT_INTERVALS}
					${EL_STRING_8_OCCURRENCE_EDITOR}
				${EL_STRING_8_ROUTINES_IMP}
					${EL_STRING_8_ROUTINES}
				${EL_STRING_8_TABLE [G]}
					${EL_FIELD_VALUE_TABLE [G]}
					${EL_DATE_FUNCTION_TABLE}
					${EVC_FUNCTION_TABLE}
					${EL_XPATH_TOKEN_TABLE}
	]"
end