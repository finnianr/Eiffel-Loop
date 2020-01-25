note
	description: "Factory to create objects conforming to [$source EL_MAKEABLE]"
	notes: "[
		Use this factory instead of [$source EL_OBJECT_FACTORY] for cases where applying
		an agent make procedure after the creation of the object violates a class invariant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 18:13:29 GMT (Saturday 25th January 2020)"
	revision: "3"

class
	EL_MAKEABLE_OBJECT_FACTORY

inherit
	ANY

	EL_MODULE_EIFFEL

feature -- Factory

	new_item_from_name (class_name: STRING): detachable EL_MAKEABLE
			--
		require
			valid_type: valid_name (class_name)
		do
			if attached {TYPE [EL_MAKEABLE]} Eiffel.type_from_string (class_name) as type then
				Result := new_item_from_type (type)
			end
		end

	new_item_from_type (type: TYPE [EL_MAKEABLE]): detachable EL_MAKEABLE
		require
			valid_type: valid_type_id (type.type_id)
		do
			if attached new_cell (type) as cell then
				Result := cell.new_item
			end
		end

feature -- Contract Support

	valid_name (class_name: STRING): BOOLEAN
		do
			if not class_name.is_empty then
				Result := valid_type_id (Eiffel.dynamic_type_from_string (class_name))
			end
		end

	valid_type_id (type_id: INTEGER): BOOLEAN
		do
			Result := {ISE_RUNTIME}.type_conforms_to (type_id, Makeable_type_id)
		end

feature {NONE} -- Implementation

	new_cell (type: TYPE [EL_MAKEABLE]): EL_MAKEABLE_CELL [EL_MAKEABLE]
		do
			if attached {like new_cell} Eiffel.new_factory_instance ({like new_cell}, type) as new then
				Result := new
			end
		end

feature {NONE} -- Constants

	Makeable_type_id: INTEGER
		once
			Result := ({EL_MAKEABLE}).type_id
		end

end
