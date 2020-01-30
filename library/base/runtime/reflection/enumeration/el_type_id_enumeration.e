note
	description: "Type id enumeration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-30 11:59:20 GMT (Thursday 30th January 2020)"
	revision: "1"

deferred class
	EL_TYPE_ID_ENUMERATION

inherit
	EL_ENUMERATION [INTEGER]
		rename
			export_name as to_upper_snake_case,
			import_name as from_upper_snake_case
		redefine
			initialize_fields
		end

feature {NONE} -- Initialization

	initialize_fields
		do
			across types as type loop
				if field_table.has_key (type_name (type.item)) then
					field_table.found_item.set_from_integer (Current, type.item.type_id)
				end
			end
		end

feature {NONE} -- Implementation

	type_name (type: TYPE [ANY]): STRING
		do
			Result := from_upper_snake_case (type.name, False)
		end

	types: ARRAY [TYPE [ANY]]
		deferred
		ensure
			matching_field_names: across Result as type all field_table.has (type.item) end
		end
end
