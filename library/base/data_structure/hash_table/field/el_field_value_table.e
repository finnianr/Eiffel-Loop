note
	description: "Table of field values of type **G** from an object conforming to [$source EL_REFLECTIVE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-30 15:20:43 GMT (Sunday 30th July 2023)"
	revision: "8"

class
	EL_FIELD_VALUE_TABLE [G]

inherit
	EL_STRING_8_TABLE [G]
		rename
			make as make_from_array
		end

create
	make, make_exported, make_conforming, make_conforming_exported

feature {NONE} -- Initialization

	make (object: EL_REFLECTIVE)
		do
			make_with_criteria (object, False, False)
		end

	make_conforming (object: EL_REFLECTIVE)
		do
			make_with_criteria (object, True, False)
		end

	make_conforming_exported (object: EL_REFLECTIVE)
		do
			make_with_criteria (object, True, True)
		end

	make_exported (object: EL_REFLECTIVE)
		do
			make_with_criteria (object, False, True)
		end

	make_with_criteria (object: EL_REFLECTIVE; conforming_types, exported_name: BOOLEAN)
		local
			type_query: EL_FIELD_TYPE_QUERY [G]
		do
			create type_query.make (object, conforming_types)
			if attached type_query.reference_fields as field_list then
				make_equal (field_list.count)
				across field_list as list loop
					if attached list.item as field and then attached {G} field.value (object) as value then
						extend (value, type_query.field_name (field, exported_name))
					end
				end

			elseif attached type_query.expanded_fields as field_list then
				make_equal (field_list.count)
				across field_list as list loop
					if attached list.item as field then
						extend (field.value (object), type_query.field_name (field, exported_name))
					end
				end
			end
		end

end