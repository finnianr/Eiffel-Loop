note
	description: "Eiffel-Loop extensions for ${REFLECTOR}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 10:14:12 GMT (Saturday 5th April 2025)"
	revision: "1"

class
	EL_REFLECTOR

inherit
	REFLECTOR

feature -- Access

	dynamic_type_from_string_8 (class_type: STRING_8): INTEGER
		-- non-caching version of `dynamic_type_from_string'
		require
			class_type_not_empty: not class_type.is_empty
			is_valid_type_string: is_valid_type_string (class_type)
		local
			l_pre_ecma_status: BOOLEAN; c_class_type: ANY
		do
		-- Take into consideration possible pre-ECMA mapping.
			l_pre_ecma_status := {ISE_RUNTIME}.pre_ecma_mapping_status
			{ISE_RUNTIME}.set_pre_ecma_mapping (not is_pre_ecma_mapping_disabled)
			c_class_type := class_type.to_c
			Result := {ISE_RUNTIME}.type_id_from_name ($c_class_type)
			{ISE_RUNTIME}.set_pre_ecma_mapping (l_pre_ecma_status)
		ensure
			dynamic_type_from_string_valid: Result = -1 or Result = none_type or Result >= 0
		end

	new_object (type: TYPE [ANY]): detachable ANY
		do
			Result := new_instance_of (type.type_id)
		end

	type_from_string (class_type: READABLE_STRING_GENERAL): detachable TYPE [ANY]
		local
			type_id: INTEGER
		do
			type_id := dynamic_type_from_string (class_type)
			if type_id > 0 then
				Result := type_of_type (type_id)
			end
		end

end