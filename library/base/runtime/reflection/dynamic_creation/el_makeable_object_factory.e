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
	date: "2020-01-17 19:15:04 GMT (Friday 17th January 2020)"
	revision: "2"

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
			if attached {like Cell_cache.item} Cell_cache.item (class_name) as cell then
				Result := cell.new_item
			end
		end

	new_item_from_type (type: TYPE [EL_MAKEABLE]): detachable EL_MAKEABLE
		require
			valid_type: valid_type_id (type.type_id)
		do
			Result := new_item_from_name (type.name)
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

	new_cell (class_name: STRING): detachable EL_MAKEABLE_CELL [EL_MAKEABLE]
		local
			name: STRING; cell_type: INTEGER
		do
			name := Makeable_cell_template.twin
			name.insert_string (class_name, name.count)
			cell_type := Eiffel.dynamic_type_from_string (name)
			if cell_type > 0 and then attached {like new_cell} Eiffel.new_instance_of (cell_type) as new then
				Result := new
			end
		end

feature {NONE} -- Constants

	Cell_cache: EL_CACHE_TABLE [EL_MAKEABLE_CELL [EL_MAKEABLE], STRING]
		once
			create Result.make_equal (7, agent new_cell)
		end

	Makeable_type_id: INTEGER
		once
			Result := ({EL_MAKEABLE}).type_id
		end

	Makeable_cell_template: STRING = "EL_MAKEABLE_CELL []"
end
