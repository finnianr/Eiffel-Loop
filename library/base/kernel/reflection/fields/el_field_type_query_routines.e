note
	description: "Field type query routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 9:14:53 GMT (Saturday 5th April 2025)"
	revision: "5"

deferred class
	EL_FIELD_TYPE_QUERY_ROUTINES

inherit
	EL_MODULE_EIFFEL

	EL_SHARED_FACTORIES

feature {NONE} -- Field tests

	is_any_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := True
		end

	is_collection_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.conforms_to_collection
		end

	is_date_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.conforms_to_date_time
		end

	is_expanded_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.is_expanded
		end

	is_field_convertable_from_string (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		-- True if field is either an expanded type (with the exception of POINTER) or conforms to one of following types
		-- 	STRING_GENERAL, EL_DATE_TIME, EL_MAKEABLE_FROM_STRING_GENERAL, BOOLEAN_REF, EL_PATH
		do
			Result := field.is_convertable_from_string
		end

	is_initializeable_collection_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			if field.is_reference and then Arrayed_list_factory.is_valid_type (field.static_type) then
				Result := field.is_convertable_from_string
			end
		end

	is_not_table_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := not field.is_table
		end

	is_string_or_expanded_field (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.is_string_or_expanded
		end

end