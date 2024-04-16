note
	description: "Common class type identifiers accesible via ${EL_SHARED_CLASS_ID}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-15 13:46:32 GMT (Monday 15th April 2024)"
	revision: "31"

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
			unicode_types := << CHARACTER_32, STRING_32, EL_ZSTRING, FILE_PATH, DIR_PATH >>
			character_data_types := <<
				CHARACTER_8, CHARACTER_32, IMMUTABLE_STRING_8, STRING_8, STRING_32, EL_ZSTRING, FILE_PATH, DIR_PATH
			>>
			readable_string_8_types := << IMMUTABLE_STRING_8, STRING_8 >>
			readable_string_32_types := << IMMUTABLE_STRING_32, STRING_32, EL_ZSTRING >>
			path_types := << EL_FILE_PATH, EL_DIR_PATH, EL_DIR_URI_PATH, EL_FILE_URI_PATH >>
		end

feature -- Access

	string_storage_type (general: READABLE_STRING_GENERAL): CHARACTER
		-- character code representing number of bytes per character in string `general'
		-- 'X' means an indeterminate number for ZSTRING type
		do
			if general.is_string_8 then
				Result := '1' -- bytes
			elseif {ISE_RUNTIME}.dynamic_type (general) = EL_ZSTRING then
				Result := 'X'
			else
				Result := '4' -- bytes
			end
		ensure
			valid_code: valid_string_storage_type (Result)
		end

feature -- Type sets

	character_data_types: ARRAY [INTEGER]
		-- set of types containing character data

	path_types : ARRAY [INTEGER]

	readable_string_8_types: ARRAY [INTEGER]

	readable_string_32_types: ARRAY [INTEGER]

	unicode_types: ARRAY [INTEGER]
		-- set of types containing character data from the Unicode character set

feature -- CHARACTER types

	CHARACTER_32: INTEGER

	CHARACTER_8: INTEGER

feature -- String types

	EL_ZSTRING: INTEGER

	IMMUTABLE_STRING_8: INTEGER

	IMMUTABLE_STRING_32: INTEGER

	STRING_32: INTEGER

	STRING_8: INTEGER

	STRING_GENERAL: INTEGER

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

	COLLECTION__ANY: INTEGER
		-- COLLECTION [ANY]

	EL_MAKEABLE_FROM_STRING__STRING_GENERAL: INTEGER
		-- EL_MAKEABLE_FROM_STRING [STRING_GENERAL]

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

	TUPLE: INTEGER

feature -- Contract Support

	valid_string_storage_type (code: CHARACTER): BOOLEAN
		do
			inspect code
				when '1', '4', 'X' then
					Result := True
			else
			end
		end
end