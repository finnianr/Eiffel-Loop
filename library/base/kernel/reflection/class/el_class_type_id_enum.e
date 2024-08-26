note
	description: "Common class type identifiers accesible via ${EL_SHARED_CLASS_ID}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 14:58:05 GMT (Monday 26th August 2024)"
	revision: "33"

class
	EL_CLASS_TYPE_ID_ENUM

inherit
	EL_TYPE_ID_ENUMERATION
		redefine
			make
		end

	EL_NUMERIC_TYPE_ID_ENUMERATION

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			unicode_types := <<
				CHARACTER_32, EL_STRING_32, IMMUTABLE_STRING_32, STRING_32, EL_ZSTRING,
				FILE_PATH, DIR_PATH, EL_DIR_URI_PATH, EL_FILE_URI_PATH
			>>
			character_data_types := <<
				CHARACTER_8, CHARACTER_32,
				IMMUTABLE_STRING_8, STRING_8,
				IMMUTABLE_STRING_32, STRING_32, ZSTRING,
				FILE_PATH, DIR_PATH, EL_FILE_URI_PATH, EL_DIR_URI_PATH
			>>
			immutable_string_types := << IMMUTABLE_STRING_8, IMMUTABLE_STRING_32 >>
			readable_string_8_types := << IMMUTABLE_STRING_8, STRING_8 >>
			readable_string_32_types := <<
				EL_FLOATING_ZSTRING, EL_STRING_32, IMMUTABLE_STRING_32, STRING_32, ZSTRING
			>>
			el_path_types := << EL_FILE_PATH, EL_DIR_PATH, EL_DIR_URI_PATH, EL_FILE_URI_PATH >>
		end

feature -- Type sets

	character_data_types: SPECIAL [INTEGER]
		-- set of types containing character data

	el_path_types: SPECIAL [INTEGER]
		-- Eiffel-Loop path types

	immutable_string_types: SPECIAL [INTEGER]

	readable_string_8_types: SPECIAL [INTEGER]

	readable_string_32_types: SPECIAL [INTEGER]

	unicode_types: SPECIAL [INTEGER]
		-- set of types containing character data from the Unicode character set

feature -- CHARACTER types

	CHARACTER_32: INTEGER

	CHARACTER_8: INTEGER

feature -- String types

	EL_FLOATING_ZSTRING: INTEGER

	EL_STRING_32: INTEGER

	EL_ZSTRING: INTEGER

	IMMUTABLE_STRING_8: INTEGER

	IMMUTABLE_STRING_32: INTEGER

	STRING_32: INTEGER

	STRING_8: INTEGER

feature -- Abstract Strings

	STRING_GENERAL: INTEGER

	READABLE_STRING_32: INTEGER

feature -- Path types

	EL_DIR_PATH: INTEGER

	EL_DIR_URI_PATH: INTEGER

	EL_FILE_PATH: INTEGER

	EL_FILE_URI_PATH: INTEGER

	EL_PATH: INTEGER

	EL_URI_PATH: INTEGER

feature -- Class aliases

	DIR_PATH: INTEGER
		do
			Result := EL_DIR_PATH
		end

	FILE_PATH: INTEGER
		do
			Result := EL_FILE_PATH
		end

	ZSTRING: INTEGER
		-- alias
		do
			Result := EL_ZSTRING
		end

feature -- Generic types

	ARRAYED_LIST__ANY: INTEGER
		-- ARRAYED_LIST [ANY]

	BAG__ANY: INTEGER
		-- BAG [ANY]

	COLLECTION__ANY: INTEGER
		-- COLLECTION [ANY]

	EL_MAKEABLE_FROM_STRING__STRING_GENERAL: INTEGER
		-- EL_MAKEABLE_FROM_STRING [STRING_GENERAL]

	EL_SUBSTRING__STRING_GENERAL: INTEGER
		-- EL_SUBSTRING [STRING_GENERAL]

feature -- Eiffel-Loop types

	EL_BOOLEAN_OPTION: INTEGER

	EL_MAKEABLE: INTEGER

	EL_QUANTITY_TEMPLATE: INTEGER

	EL_REFLECTIVE: INTEGER

	EL_STORABLE: INTEGER

feature -- Other types

	ANY: INTEGER

	BOOLEAN: INTEGER

	COMPARABLE: INTEGER

	DATE_TIME: INTEGER

	PATH: INTEGER

	TUPLE: INTEGER

end