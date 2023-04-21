note
	description: "Common class type identifiers accesible via [$source EL_SHARED_CLASS_ID]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-21 9:54:40 GMT (Friday 21st April 2023)"
	revision: "25"

class
	EL_CLASS_TYPE_ID_ENUM

inherit
	EL_TYPE_ID_ENUMERATION
		redefine
			make
		end

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
			path_types := << EL_FILE_PATH, EL_DIR_PATH >>
		end

feature -- Type sets

	character_data_types: ARRAY [INTEGER]
		-- set of types containing character data

	path_types : ARRAY [INTEGER]

	readable_string_8_types: ARRAY [INTEGER]

	unicode_types: ARRAY [INTEGER]
		-- set of types containing character data from the Unicode character set

feature -- CHARACTER types

	CHARACTER_32: INTEGER

	CHARACTER_8: INTEGER

feature -- INTEGER types

	INTEGER_16: INTEGER

	INTEGER_32: INTEGER

	INTEGER_64: INTEGER

	INTEGER_8: INTEGER

feature -- NATURAL types

	NATURAL_16: INTEGER

	NATURAL_32: INTEGER

	NATURAL_64: INTEGER

	NATURAL_8: INTEGER

feature -- REAL types

	REAL_32: INTEGER

	REAL_64: INTEGER

feature -- String types

	EL_ZSTRING: INTEGER

	IMMUTABLE_STRING_8: INTEGER

	STRING_32: INTEGER

	STRING_8: INTEGER

	STRING_GENERAL: INTEGER

feature -- Path types

	EL_DIR_PATH: INTEGER

	EL_FILE_PATH: INTEGER

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

feature -- Parameterized

	ARRAYED_LIST_ANY: INTEGER
		once
			Result := ({ARRAYED_LIST [ANY]}).type_id
		end

	COLLECTION_ANY: INTEGER
		once
			Result := ({COLLECTION [ANY]}).type_id
		end

feature -- Eiffel-Loop types

	EL_MAKEABLE_FROM_STRING: INTEGER
		once
			Result := ({EL_MAKEABLE_FROM_STRING [STRING_GENERAL]}).type_id
		end

	EL_BOOLEAN_OPTION: INTEGER

	EL_MAKEABLE: INTEGER

	EL_QUANTITY_TEMPLATE: INTEGER

	EL_REFLECTIVE: INTEGER

	EL_STORABLE: INTEGER

feature -- Other types

	COMPARABLE: INTEGER

	ANY: INTEGER

	BOOLEAN: INTEGER

	DATE_TIME: INTEGER

	TUPLE: INTEGER

end