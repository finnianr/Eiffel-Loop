note
	description: "Common class type identifiers accesible via ${EL_SHARED_CLASS_ID}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-09 15:34:47 GMT (Monday 9th September 2024)"
	revision: "35"

class
	EL_CLASS_TYPE_ID_ENUM

inherit
	EL_TYPE_ID_ENUMERATION
		redefine
			make
		end

	EL_MODULE_EIFFEL

	EL_NUMERIC_TYPE_ID_ENUMERATION

	EL_TYPE_CATEGORY_CONSTANTS

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
			readable_string_8_types := <<
				IMMUTABLE_STRING_8, STRING_8, EL_STRING_8, EL_URI, EL_URL, EL_UTF_8_STRING
			>>
			readable_string_32_types := <<
				EL_FLOATING_ZSTRING, EL_STRING_32, IMMUTABLE_STRING_32, STRING_32, ZSTRING
			>>
			el_path_types := << EL_FILE_PATH, EL_DIR_PATH, EL_DIR_URI_PATH, EL_FILE_URI_PATH >>
		end

feature -- Access

	object_type_category (object: ANY): NATURAL_8
		do
			Result := type_category ({ISE_RUNTIME}.dynamic_type (object))
		end

	type_category (type_id: INTEGER): NATURAL_8
		do
			if attached Eiffel as eif then
				if eif.is_type_in_set (type_id, readable_string_8_types) then
					Result := C_readable_string_8

				elseif eif.is_type_in_set (type_id, readable_string_32_types) then
					Result := C_readable_string_32

				elseif eif.is_type_in_set (type_id, el_path_types) then
					Result := C_el_path

				elseif type_id = EL_PATH_STEPS then
					Result := C_el_path_steps

				elseif type_id = PATH then
					Result := C_path

				elseif eif.type_conforms_to (type_id, EL_PATH) then
					Result := C_el_path

				elseif eif.type_conforms_to (type_id, TYPE__ANY) then
					Result := C_type_any

				elseif eif.type_conforms_to (type_id, READABLE_STRING_8) then
					Result := C_readable_string_8

				elseif eif.type_conforms_to (type_id, READABLE_STRING_32) then
					Result := C_readable_string_32

				end
			end
		end

feature -- Type sets

	character_data_types: SPECIAL [INTEGER]
		-- set of types containing character data

	el_path_types: SPECIAL [INTEGER]
		-- Eiffel-Loop path types

	immutable_string_types: SPECIAL [INTEGER]

	readable_string_32_types: SPECIAL [INTEGER]

	readable_string_8_types: SPECIAL [INTEGER]

	unicode_types: SPECIAL [INTEGER]
		-- set of types containing character data from the Unicode character set

feature -- CHARACTER types

	CHARACTER_32: INTEGER

	CHARACTER_8: INTEGER

feature -- String types

	EL_FLOATING_ZSTRING: INTEGER

	EL_STRING_32: INTEGER

	EL_STRING_8: INTEGER

	EL_UTF_8_STRING: INTEGER

	EL_URI: INTEGER

	EL_URL: INTEGER

	EL_ZSTRING: INTEGER

	IMMUTABLE_STRING_32: INTEGER

	IMMUTABLE_STRING_8: INTEGER

	STRING_32: INTEGER

	STRING_8: INTEGER

feature -- Abstract Strings

	READABLE_STRING_8: INTEGER

	READABLE_STRING_32: INTEGER

	STRING_GENERAL: INTEGER

feature -- Path types

	EL_DIR_PATH: INTEGER

	EL_DIR_URI_PATH: INTEGER

	EL_FILE_PATH: INTEGER

	EL_FILE_URI_PATH: INTEGER

	EL_PATH: INTEGER

	EL_PATH_STEPS: INTEGER

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

	HASH_TABLE__ANY__HASHABLE: INTEGER
		-- HASH_TABLE [ANY, HASHABLE]

	EL_MAKEABLE_FROM_STRING__STRING_GENERAL: INTEGER
		-- EL_MAKEABLE_FROM_STRING [STRING_GENERAL]

	EL_SUBSTRING__STRING_GENERAL: INTEGER
		-- EL_SUBSTRING [STRING_GENERAL]

	TYPE__ANY: INTEGER
		-- TYPE [ANY]

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