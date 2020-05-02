note
	description: "[
		Enumeration of type ids by correspondence of fields names to type names.
		Example: [$source EL_CLASS_TYPE_ID_ENUM]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-28 8:27:53 GMT (Tuesday 28th April 2020)"
	revision: "7"

deferred class
	EL_TYPE_ID_ENUMERATION

inherit
	EL_ENUMERATION [INTEGER]
		rename
			export_name as to_snake_case_upper,
			import_name as from_snake_case_upper
		redefine
			initialize_fields
		end

	EL_MODULE_EIFFEL

feature {NONE} -- Initialization

	initialize_fields
		local
			type_id: INTEGER
		do
			across field_table as field loop
				if attached {EL_REFLECTED_INTEGER_32} field.item as integer then
					type_id := Eiffel.dynamic_type_from_string (integer.export_name)
					if type_id > 0 then
						integer.set (Current, type_id)
						type_id_count := type_id_count.next
					else
						check
							valid_type_name: False
						end
					end
				end
			end
		ensure then
			all_initialized: type_id_count = field_table.count.to_character_32
		end

feature {NONE} -- Internal attributes

	type_id_count: CHARACTER_32
		-- using CHARACTER_32 as counter so it won't be included as part of enumeration

end
