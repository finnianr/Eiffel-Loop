note
	description: "Factory to create objects conforming to [$source EL_MAKEABLE]"
	notes: "[
		Use this factory instead of [$source EL_OBJECT_FACTORY] for cases where applying
		an agent make procedure after the creation of the object might violate a class invariant.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-16 19:05:12 GMT (Thursday 16th January 2020)"
	revision: "1"

class
	EL_MAKEABLE_OBJECT_FACTORY

inherit
	ANY

	EL_MODULE_EIFFEL

feature -- Factory

	instance_from_class_name (class_name: STRING): EL_MAKEABLE
			--
		require
			valid_type: valid_type (class_name)
		do
			if attached {like Cell_cache.item} Cell_cache.item (class_name) as cell then
				Result := cell.new_item
			end
		end

feature -- Contract Support

	valid_type (class_name: STRING): BOOLEAN
		-- `True' if type named `class_name' conforms to `EL_MAKEABLE'
		local
			id: INTEGER
		do
			if not class_name.is_empty then
				id := Eiffel.dynamic_type_from_string (class_name)
				Result := {ISE_RUNTIME}.type_conforms_to (id, Makeable_type_id)
			end
		end

feature {NONE} -- Implementation

	new_makeable_cell (class_name: STRING): EL_MAKEABLE_CELL [EL_MAKEABLE]
		local
			name: STRING; cell_type: INTEGER
		do
			name := Makeable_cell_template.twin
			name.insert_string (class_name, name.count)
			cell_type := Eiffel.dynamic_type_from_string (name)
			if cell_type > 0 and then attached {like new_makeable_cell} Eiffel.new_instance_of (cell_type) as l_result then
				Result := l_result
			end
		end

feature {NONE} -- Constants

	Cell_cache: EL_CACHE_TABLE [EL_MAKEABLE_CELL [EL_MAKEABLE], STRING]
		once
			create Result.make_equal (7, agent new_makeable_cell)
		end

	Makeable_type_id: INTEGER
		once
			Result := ({EL_MAKEABLE}).type_id
		end

	Makeable_cell_template: STRING = "EL_MAKEABLE_CELL []"
end
