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
	date: "2025-03-18 7:04:25 GMT (Tuesday 18th March 2025)"
	revision: "13"

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
				if table.has_key (key) then
					if attached {EL_REFLECTED_NUMERIC_FIELD [NUMERIC]} table.found_item as field then
						Result := field.reference_value (current_reflective)
					else
						Result := table.found_item.reference_value (current_reflective)
						if attached {READABLE_STRING_GENERAL} Result as general then
							Result := escaped_field (general, table.found_item.type_id)
						end
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