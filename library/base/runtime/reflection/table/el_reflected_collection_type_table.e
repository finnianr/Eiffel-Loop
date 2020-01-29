note
	description: "Reflected collection type table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 17:08:03 GMT (Wednesday 29th January 2020)"
	revision: "3"

class
	EL_REFLECTED_COLLECTION_TYPE_TABLE [G]

inherit
	EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_COLLECTION [G]]
		rename
			make as make_with_tuples
		redefine
			new_base_type_id
		end

	REFLECTOR
		export
			{NONE} all
		undefine
			is_equal, copy, default_create
		end

create
	make

feature {NONE} -- Initialization

	make (array: ARRAY [TYPE [G]])
		local
			type_name: ZSTRING
		do
			make_size (array.count)
			across array as type loop
				type_name := Type_template #$ [type.item.name]
				if attached {EL_COLLECTION_TYPE_ASSOCIATION [G]} Factory.new_item_from_name (type_name) as association then
					extend (association.reflected_field_type, association.type_id)
				end
			end
			initialize
		end

feature {NONE} -- Implementation

	new_base_type_id: INTEGER
		do
			Result := ({COLLECTION [G]}).type_id
		end

feature {NONE} -- Constants

	Factory: EL_MAKEABLE_OBJECT_FACTORY
		once
			create Result
		end

	Type_template: ZSTRING
		once
			create Result.make_from_general (({EL_COLLECTION_TYPE_ASSOCIATION [ANY]}).name)
			Result.replace_delimited_substring_general ("[", "]", "%S", False, 1)
		end

end
