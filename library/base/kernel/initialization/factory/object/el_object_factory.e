note
	description: "[
		Factory for instances of Eiffel classes conforming to parameter `G'
		
		Tuple arguments act as type manifests with each type `A, B, C..' conforming to `G'. 
		A contract ensures all types conform. Typically you would create the tuple like this:
		
			Types: TUPLE [A, B, C ..]
				once
					create Result
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-22 5:26:19 GMT (Saturday 22nd June 2024)"
	revision: "30"

class
	EL_OBJECT_FACTORY [G]

inherit
	ANY
		redefine
			default_create
		end

	EL_STRING_GENERAL_ROUTINES

	EL_MODULE_EIFFEL

create
	make, default_create

feature {NONE} -- Initialization

	default_create
		do
			create types_indexed_by_name.make_equal (5)
			create default_alias.make_empty
		end

	make (mapping_table: ARRAY [TUPLE [name: READABLE_STRING_GENERAL; type: TYPE [G]]])
		require
			not_empty: not mapping_table.is_empty
		local
			key: ZSTRING
		do
			default_create
			types_indexed_by_name.accommodate (mapping_table.count)
			across mapping_table as map loop
				key := as_zstring (map.item.name)
				if map.cursor_index = 1 then
					default_alias := key
				end
				types_indexed_by_name [key] := map.item.type
			end
		end

feature -- Factory

	new_item_from_type (type: TYPE [G]): detachable G
		-- new item from dynamic type `type_id'
		do
			Result := new_item_from_type_id (type.type_id)
		end

	new_item_from_type_id (type_id: INTEGER): detachable G
		-- new item from dynamic type `type_id'
		require
			valid_type_id: valid_type_id (type_id)
		do
			if type_id >= 0 and then attached {G} Eiffel.new_instance_of (type_id) as new then
				Result := new
			end
		end

	new_item_from_alias (a_alias: READABLE_STRING_GENERAL): detachable G
			-- uninitialized instance for type corresponding to `type_alias'
			-- or else instance for `default_alias' if `type_alias' cannot be found
		require
			valid_type: a_alias /= default_alias implies valid_alias (a_alias)
			valid_default_type: a_alias = default_alias implies valid_alias (default_alias)
		do
			if types_indexed_by_name.has_general_key (a_alias) then
				Result := new_item_from_type (types_indexed_by_name.found_item)
			else
				Result := new_item_from_alias (default_alias)
			end
		end

	new_item_from_name (class_name: READABLE_STRING_GENERAL): detachable G
			--
		require
			valid_type: valid_name (class_name)
		do
			Result := new_item_from_type_id (Eiffel.dynamic_type_from_string (class_name))
		end

feature -- Access

	alias_names: EL_ZSTRING_LIST
		do
			create Result.make_from_array (types_indexed_by_name.current_keys)
		end

	count: INTEGER
		do
			Result := types_indexed_by_name.count
		end

	default_alias: ZSTRING

feature -- Element change

	force (type: TYPE [G]; name: ZSTRING)
		do
			types_indexed_by_name.force (type, name)
		end

	put (type: TYPE [G]; name: ZSTRING)
		do
			types_indexed_by_name.put (type, name)
		end

feature -- Contract support

	has_alias (a_alias: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := types_indexed_by_name.has_general (a_alias)
		end

	valid_alias (a_alias: READABLE_STRING_GENERAL): BOOLEAN
		do
			if types_indexed_by_name.has_general_key (a_alias) then
				Result := valid_name (types_indexed_by_name.found_item)
			end
		end

	valid_name (class_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if not class_name.is_empty then
				Result := valid_type_id (Eiffel.dynamic_type_from_string (class_name))
			end
		end

	valid_type_id (type_id: INTEGER): BOOLEAN
		do
			Result := {ISE_RUNTIME}.type_conforms_to (type_id, ({G}).type_id)
		end

feature {NONE} -- Internal attributes

	types_indexed_by_name: EL_ZSTRING_HASH_TABLE [TYPE [G]]
		-- map of alias names to types

end