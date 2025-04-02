note
	description: "Common class type identifiers accesible via ${EL_SHARED_CLASS_ID}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-02 12:36:21 GMT (Wednesday 2nd April 2025)"
	revision: "39"

class
	EL_CLASS_TYPE_ID_ENUM

inherit
	EL_TYPE_ID_ENUMERATION
		redefine
			make
		end

	EL_TYPE_UTILITIES
		export
			{NONE} all
		end

	EL_NUMERIC_TYPE_ID_ENUMERATION

	EL_STRING_TYPE_ID_ENUMERATION

	EL_TYPE_CATEGORY_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			integer_types := numeric_types (<< INTEGER_16, INTEGER_32, INTEGER_64, INTEGER_8 >>)
			natural_types := numeric_types (<< NATURAL_16, NATURAL_32, NATURAL_64, NATURAL_8 >>)
			real_types := numeric_types (<< REAL_32, REAL_64 >>)

			immutable_string_types := << IMMUTABLE_STRING_8, IMMUTABLE_STRING_32 >>
			readable_string_8_types := <<
				IMMUTABLE_STRING_8, STRING_8, EL_STRING_8, EL_URI, EL_URL, EL_UTF_8_STRING
			>>
			readable_string_32_types := <<
				STRING_32, EL_STRING_32, IMMUTABLE_STRING_32, ZSTRING, EL_FLOATING_ZSTRING
			>>
			el_path_types := << EL_FILE_PATH, EL_DIR_PATH, EL_DIR_URI_PATH, EL_FILE_URI_PATH >>

			unicode_types := joined (joined (<< CHARACTER_32 >>, readable_string_32_types), el_path_types)
			character_data_types := joined (
				joined (<< CHARACTER_8, CHARACTER_32 >>, el_path_types),
				joined (readable_string_8_types, readable_string_32_types)
			)
		end

feature -- Access

	object_type_category (object: ANY): NATURAL_8
		do
			Result := type_category ({ISE_RUNTIME}.dynamic_type (object))
		end

	type_category (type_id: INTEGER): NATURAL_8
		do
			if is_type_in_set (type_id, readable_string_8_types) then
				Result := C_readable_string_8

			elseif is_type_in_set (type_id, readable_string_32_types) then
				Result := C_readable_string_32

			elseif is_type_in_set (type_id, el_path_types) then
				Result := C_el_path

			elseif is_type_in_set (type_id, real_types) then
				Result := C_real

			elseif is_type_in_set (type_id, integer_types) then
				Result := C_integer

			elseif is_type_in_set (type_id, natural_types) then
				Result := C_natural

			elseif type_id = EL_PATH_STEPS then
				Result := C_el_path_steps

			elseif type_id = PATH then
				Result := C_path

		-- `type_conforms_to' are last because they take longer to execute
			elseif type_conforms_to (type_id, EL_PATH) then
				Result := C_el_path

			elseif type_conforms_to (type_id, TYPE__ANY) then
				Result := C_type_any -- TYPE [ANY]

			elseif type_conforms_to (type_id, READABLE_STRING_8) then
				Result := C_readable_string_8

			elseif type_conforms_to (type_id, READABLE_STRING_32) then
				Result := C_readable_string_32

			end
		end

feature -- Type sets

	character_data_types: SPECIAL [INTEGER]
		-- set of types containing character data

	el_path_types: SPECIAL [INTEGER]
		-- Eiffel-Loop path types

	unicode_types: SPECIAL [INTEGER]
		-- set of types containing character data from the Unicode character set

feature -- CHARACTER types

	CHARACTER_32: INTEGER

	CHARACTER_8: INTEGER

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

	HASH_TABLE__ANY__HASHABLE: INTEGER
		-- HASH_TABLE [ANY, HASHABLE]

	NUMERIC: INTEGER

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

feature {NONE} -- Implementation

	joined (types_1, types_2: SPECIAL [INTEGER]): SPECIAL [INTEGER]
		local
			list_1, list_2: EL_ARRAYED_LIST [INTEGER]
		do
			create list_1.make_from_special (types_1)
			create list_2.make_from_special (types_2)
			list_1.grow (list_1.count + list_2.count)
			list_1.append (list_2)
			Result := list_1.area
		end

	numeric_types (expanded_types: ARRAY [INTEGER]): SPECIAL [INTEGER]
		-- add corresponding reference types to `expanded_types'
		require
			all_expanded:
				across expanded_types as type all
					type_of_type (type.item).is_expanded
				end
		local
			list: EL_ARRAYED_LIST [INTEGER]
		do
			create list.make_from_array (expanded_types)
			list.grow (list.count * 2)
			across expanded_types as type loop
				list.extend (reference_type_of (type.item))
			end
			Result := list.area
		end

end