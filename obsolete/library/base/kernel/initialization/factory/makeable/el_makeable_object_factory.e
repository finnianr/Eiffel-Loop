note
	description: "Factory to create objects conforming to ${EL_MAKEABLE}"
	notes: "[
		Use this factory instead of ${EL_OBJECT_FACTORY} for cases where applying
		an agent make procedure after the creation of the object violates a class invariant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "9"

class
	EL_MAKEABLE_OBJECT_FACTORY

obsolete
	"Use {EL_SHARED_FACTORIES}.Makeable_factory"

inherit
	ANY

	EL_MODULE_EIFFEL; EL_MODULE_FACTORY

	EL_SHARED_CLASS_ID

feature -- Factory

	new_item_from_name (class_name: READABLE_STRING_GENERAL): detachable EL_MAKEABLE
			--
		require
			valid_type: valid_name (class_name)
		do
			if attached {TYPE [EL_MAKEABLE]} Eiffel.type_from_string (class_name) as type then
				Result := new_item_from_type (type)
			end
		end

	new_item_from_type (makeable: TYPE [EL_MAKEABLE]): detachable EL_MAKEABLE
		require
			valid_type: valid_makeable_id (makeable.type_id)
		do
			Result := new_item_from_type_id (makeable.type_id)
		end

	new_item_from_type_id (makeable_type_id: INTEGER): detachable EL_MAKEABLE
		require
			valid_type: valid_makeable_id (makeable_type_id)
		do
			if attached new_cell (makeable_type_id) as cell then
				Result := cell.new_item
			end
		end

feature -- Contract Support

	valid_name (class_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if not class_name.is_empty then
				Result := valid_makeable_id (Eiffel.dynamic_type_from_string (class_name))
			end
		end

	valid_makeable_id (makeable_type_id: INTEGER): BOOLEAN
		do
			Result := {ISE_RUNTIME}.type_conforms_to (makeable_type_id, Class_id.EL_MAKEABLE)
		end

feature {NONE} -- Implementation

	new_cell (makeable_type_id: INTEGER): EL_MAKEABLE_FACTORY [EL_MAKEABLE]
		require
			valid_target: valid_makeable_id (makeable_type_id)
		do
			if attached {like new_cell} Factory.new ({like new_cell}, makeable_type_id) as new then
				Result := new
			end
		end

end
