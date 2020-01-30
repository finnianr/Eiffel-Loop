note
	description: "Type id enumeration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-30 14:58:36 GMT (Thursday 30th January 2020)"
	revision: "3"

deferred class
	EL_TYPE_ID_ENUMERATION

inherit
	EL_ENUMERATION [INTEGER]
		rename
			export_name as to_upper_snake_case,
			import_name as from_upper_snake_case
		redefine
			initialize_fields, make
		end

	EL_MODULE_EIFFEL

feature {NONE} -- Initialization

	make
		do
			create type_id_count
			Precursor
		end

	initialize_fields
		local
			type_id: INTEGER
		do
			across field_table as field loop
				if attached {EL_REFLECTED_INTEGER_32} field.item as integer then
					type_id := Eiffel.dynamic_type_from_string (integer.export_name)
					if type_id > 0 then
						integer.set (Current, type_id)
						type_id_count.set_item (type_id_count + 1)
					end
				end
			end
		ensure then
			all_initialized: type_id_count.to_integer_32 = count
		end

feature {NONE} -- Internal attributes

	type_id_count: INTEGER_REF
		-- Must be reference in order not be included as type_id

end
