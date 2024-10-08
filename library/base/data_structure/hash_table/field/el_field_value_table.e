note
	description: "Table of field values of type **G** from an object conforming to ${EL_REFLECTIVE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:00:56 GMT (Sunday 22nd September 2024)"
	revision: "10"

class
	EL_FIELD_VALUE_TABLE [G]

inherit
	EL_STRING_8_TABLE [G]
		rename
			make as make_sized
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