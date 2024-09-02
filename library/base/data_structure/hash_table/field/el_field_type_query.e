note
	description: "[
		Query an object conforming to type ${EL_REFLECTIVE} for fields of parameter type **G**
		or optionally conforming to type **G**
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-02 11:54:11 GMT (Monday 2nd September 2024)"
	revision: "11"

class
	EL_FIELD_TYPE_QUERY [G]

inherit
	ANY

	EL_REFLECTION_HANDLER

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	make (object: EL_REFLECTIVE; conforming: BOOLEAN)
		do
			type_id := ({G}).type_id
			abstract_type := Eiffel.abstract_type_of_type (type_id)

			if is_reference then
				reference_fields := new_reference_fields (object.field_table, conforming)
			else
				expanded_fields := new_expanded_fields (object.field_table)
			end
		ensure
			initialized_for_reference: is_reference implies attached reference_fields
			initialized_for_expanded: is_expanded implies attached expanded_fields
		end

feature -- Access

	abstract_type: INTEGER

	field_name (field: EL_REFLECTED_FIELD; exported_name: BOOLEAN): READABLE_STRING_8
		do
			if exported_name then
				Result := field.export_name
			else
				Result := field.name
			end
		end

	type_id: INTEGER

feature -- Query results

	expanded_fields: detachable like new_expanded_fields

	reference_fields: detachable like new_reference_fields

feature -- Status query

	is_expanded: BOOLEAN
		do
			Result := not is_reference
		end

	is_reference: BOOLEAN
		do
			Result := abstract_type = {REFLECTOR_CONSTANTS}.Reference_type
		end

feature -- Basic operations

	set_values (object: EL_REFLECTIVE; new_value: FUNCTION [READABLE_STRING_8, G]; exported_name: BOOLEAN)
		do
			if attached reference_fields as field_list then
				across field_list as list loop
					if attached list.item as field then
						field.set (object, new_value (field_name (field, exported_name)))
					end
				end

			elseif attached expanded_fields as field_list then
				across field_list as list loop
					if attached list.item as field then
						field.set (object, new_value (field_name (field, exported_name)))
					end
				end
			end
		end

feature {NONE} -- Implementation

	new_expanded_fields (table: EL_FIELD_TABLE): SPECIAL [EL_REFLECTED_EXPANDED_FIELD [G]]
		do
			create Result.make_empty (table.count)
			from table.start until table.after loop
				if attached {EL_REFLECTED_EXPANDED_FIELD [G]} table.item_for_iteration as field then
					Result.extend (field)
				end
				table.forth
			end
		end

	new_reference_fields (table: EL_FIELD_TABLE; conforming: BOOLEAN): SPECIAL [EL_REFLECTED_REFERENCE [ANY]]
		do
			create Result.make_empty (table.count)
			from table.start until table.after loop
				if attached {EL_REFLECTED_REFERENCE [ANY]} table.item_for_iteration as field then
					if conforming then
						if Eiffel.field_conforms_to (field.type_id, type_id) then
							Result.extend (field)
						end
					else
						if field.type_id = type_id then
							Result.extend (field)
						end
					end
				end
				table.forth
			end
		end

end