note
	description: "[
		Object with table of attributes of type G that are initialized by call to
		${EL_REFLECTED_FIELD}.set_from_string `(value)' where **value** is either the 
		name of the field or a value looked up in the `new_text_table' manifest.
	]"
	descendants: "[
			EL_REFLECTIVE_ATTRIBUTE_TABLE* [G]
				${DATA_DIRECTORIES}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 7:55:23 GMT (Monday 5th May 2025)"
	revision: "2"

deferred class EL_REFLECTIVE_ATTRIBUTE_TABLE [G] inherit ANY

	EL_MODULE_EIFFEL

feature {NONE} -- Initialization

	initialize (field_list: EL_FIELD_LIST)
		do
		end

	make
		local
			value_table: EL_IMMUTABLE_UTF_8_TABLE
		do
			create value_table.make_indented_eiffel (new_text_table)
			if attached new_field_list as field_list then
				create attribute_list.make (field_list.count)
				across field_list as list loop
					if attached list.item as field then
						if not field.is_expanded then
							field.initialize (Current)
						end
						if value_table.has_immutable_key (field.name) then
							field.set_from_string (Current, value_table.found_item)
						else
							field.set_from_string (Current, field.name)
						end
						if attached {G} field.value (Current) as value then
							attribute_list.extend (value)
						end
					end
				end
				initialize (field_list)
			end
		end

feature -- Access

	attribute_list: EL_ARRAYED_LIST [G] note option: transient attribute end

feature {NONE} -- Implementation

	attribute_type: INTEGER
		do
			Result := Eiffel.abstract_type_of_type (({G}).type_id)
		end

	new_field_list: EL_FIELD_LIST
		do
			create Result.make_abstract (Current, attribute_type, True)
		end

feature {NONE} -- Deferred

	new_text_table: READABLE_STRING_GENERAL
		-- manifest of attributes that are not eiffel attribute identifiers
		deferred
		end
end