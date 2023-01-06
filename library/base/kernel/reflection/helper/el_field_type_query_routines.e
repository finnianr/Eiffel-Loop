note
	description: "Field type query routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-06 14:01:35 GMT (Friday 6th January 2023)"
	revision: "1"

deferred class
	EL_FIELD_TYPE_QUERY_ROUTINES

inherit
	EL_MODULE_EIFFEL

	EL_SHARED_FACTORIES

feature {NONE} -- Field tests

	is_any_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := True
		end

	is_collection_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := Eiffel.field_conforms_to_collection (basic_type, type_id)
		end

	is_date_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := Eiffel.field_conforms_to_date_time (basic_type, type_id)
		end

	is_field_convertable_from_string (basic_type, type_id: INTEGER): BOOLEAN
		-- True if field is either an expanded type (with the exception of POINTER) or conforms to one of following types
		-- 	STRING_GENERAL, EL_DATE_TIME, EL_MAKEABLE_FROM_STRING_GENERAL, BOOLEAN_REF, EL_PATH
		do
			Result := Eiffel.is_type_convertable_from_string (basic_type, type_id)
		end

	is_initializeable_collection_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			if Eiffel.is_reference (basic_type) and then Arrayed_list_factory.is_valid_type (type_id) then
				Result := Eiffel.is_type_convertable_from_string (basic_type, Eiffel.collection_item_type (type_id))
			end
		end

	is_string_or_expanded_field (basic_type, type_id: INTEGER): BOOLEAN
		do
			Result := Eiffel.is_string_or_expanded_type (basic_type, type_id)
		end

end