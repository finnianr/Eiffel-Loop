note
	description: "[
		Evolicity Eiffel context with attribute field values available available by reflection
	]"
	notes: "[
		Escaping of string field values is available by implemenation of `escaped_field'.
		Rename to `unescaped_field' in descendant if escaping not required.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 8:58:39 GMT (Saturday 22nd March 2025)"
	revision: "14"

deferred class
	EVC_REFLECTIVE_EIFFEL_CONTEXT

inherit
	EVC_EIFFEL_CONTEXT
		redefine
			context_item, has_variable
		end

	EL_REFLECTIVE_I

feature -- Status query

	has_variable (variable_name: STRING): BOOLEAN
			--
		do
			Result := getter_functions.has (variable_name) or else field_table.has (variable_name)
		end

feature {NONE} -- Implementation

	context_item (variable_ref: EVC_VARIABLE_REFERENCE; index: INTEGER): ANY
		local
			table: EL_FIELD_TABLE
		do
			table := field_table
			if attached variable_ref [index] as key then
				if table.has_key (key) and then attached table.found_item as field then
					if field.is_string_type
						and then attached {EL_REFLECTED_STRING [READABLE_STRING_GENERAL]} field as string_field
					then
						Result := escaped_field (string_field.value (current_reflective), field.type_id)

					elseif field.is_expanded then
						Result := field.reference_value (current_reflective)
					else
						Result := field.value (current_reflective) -- already a reference
					end
				else
					Result := Precursor (variable_ref, index)
				end
			end
		end

feature {NONE} -- Evolicity fields

	empty_function_table: like getter_functions
		do
			create Result.make_equal (0)
		end

feature {NONE} -- Implementation

	escaped_field (a_string: READABLE_STRING_GENERAL; type_id: INTEGER): READABLE_STRING_GENERAL
		-- escaped value of each string field
		-- rename to `unescaped_field' in descendant if escaping not required
		deferred
		end

	unescaped_field (a_string: READABLE_STRING_GENERAL; type_id: INTEGER): READABLE_STRING_GENERAL
		do
			Result := a_string
		end

end