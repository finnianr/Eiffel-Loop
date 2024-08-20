note
	description: "[
		${EL_STRING_BIT_COUNTABLE} applicable to generic class taking a string parameter conforming
		to ${READABLE_STRING_32}
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 12:36:12 GMT (Tuesday 20th August 2024)"
	revision: "4"

deferred class
	EL_STRING_32_BIT_COUNTABLE [S -> READABLE_STRING_32]

inherit
	EL_STRING_BIT_COUNTABLE [S]
		undefine
			bit_count
		end

	EL_32_BIT_IMPLEMENTATION

note
	descendants: "[
			EL_STRING_32_BIT_COUNTABLE* [S -> ${READABLE_STRING_32}]
				${EL_IMMUTABLE_STRING_32_TABLE}
				${EL_STRING_32_TABLE [G]}
				${EL_COMPACT_ZSTRING_LIST}
				${EL_SPLIT_STRING_32_LIST}
				${EL_IMMUTABLE_32_MANAGER}
				${EL_STRING_32_BUFFER_I*}
					${EL_STRING_32_BUFFER_ROUTINES}
					${EL_STRING_32_BUFFER}
				${EL_ZSTRING_ESCAPER_IMP}
					${XML_ZSTRING_ESCAPER_IMP}
					${EL_CSV_ZSTRING_ESCAPER_IMP}
				${EL_STRING_32_ESCAPER_IMP}
					${XML_STRING_32_ESCAPER_IMP}
					${EL_CSV_STRING_32_ESCAPER_IMP}
				${EL_BORROWED_STRING_32_CURSOR}
				${EL_IMMUTABLE_STRING_32_GRID}
				${EL_STRING_32_READER_WRITER}
				${EL_ZSTRING_READER_WRITER}
				${EL_STRING_32_OCCURRENCE_INTERVALS}
					${EL_STRING_32_SPLIT_INTERVALS}
					${EL_STRING_32_OCCURRENCE_EDITOR}
				${EL_ZSTRING_BUFFER_I*}
					${EL_ZSTRING_BUFFER}
					${EL_ZSTRING_BUFFER_ROUTINES}
				${EL_BORROWED_ZSTRING_CURSOR}
				${EL_SPLIT_ZSTRING_LIST}
				${EL_ZSTRING_ROUTINES_IMP}
					${EL_ZSTRING_ROUTINES}
					${EL_REFLECTED_PATH}
				${EL_STRING_32_ROUTINES_IMP}
					${EL_STRING_32_ROUTINES}
	]"
end