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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-07 7:47:36 GMT (Friday 7th August 2020)"
	revision: "21"

class
	EL_OBJECT_FACTORY [G]

inherit
	ANY
		redefine
			default_create
		end

	EL_MODULE_EIFFEL

	EL_MODULE_NAMING

	EL_MODULE_ZSTRING

create
	make, make_words_lower, make_words_upper, make_from_table, default_create

feature {NONE} -- Initialization

	default_create
		do
			create types_indexed_by_name.make_equal (5)
			type_alias := agent Naming.class_with_separator_as_lower (?, ' ', 0, 0)
			create default_alias.make_empty
		end

	make (a_type_alias: like type_alias; type_tuple: TUPLE)
			-- Store type MY_USEFUL_CLASS as alias "my${separator}useful" with suffix_word_count = 1
		require
			not_types_empty: type_tuple.count >= 1
			all_aliases_not_empty: all_aliases_not_empty (a_type_alias, type_tuple)
		local
			type_list: like new_type_list
		do
			default_create
			type_alias := a_type_alias
			types_indexed_by_name.accommodate (type_tuple.count)
			type_list:= new_type_list (type_tuple)
			type_list.do_all (agent extend)
			set_default_alias (type_list [1])
		end

	make_from_table (mapping_table: ARRAY [TUPLE [name: READABLE_STRING_GENERAL; type: TYPE [G]]])
		require
			not_empty: not mapping_table.is_empty
		local
			key: ZSTRING
		do
			default_create
			types_indexed_by_name.accommodate (mapping_table.count)
			across mapping_table as map loop
				key := Zstring.as_zstring (map.item.name)
				if map.cursor_index = 1 then
					default_alias := key
				end
				types_indexed_by_name [key] := map.item.type
			end
		end

	make_words_lower (a_suffix_word_count: INTEGER; type_tuple: TUPLE)
		do
			make (agent Naming.class_with_separator_as_lower (?, ' ', 0, a_suffix_word_count), type_tuple)
		end

	make_words_upper (a_suffix_word_count: INTEGER; type_tuple: TUPLE)
		do
			make (agent Naming.class_with_separator (?, ' ', 0, a_suffix_word_count), type_tuple)
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
			if types_indexed_by_name.has_key (General.to_zstring (a_alias)) then
				Result := new_item_from_type (types_indexed_by_name.found_item)
			else
				Result := new_item_from_alias (default_alias)
			end
		end

	new_item_from_name (class_name: READABLE_STRING_GENERAL): detachable G
			--
		require
			valid_type: valid_name (class_name)
		local
			type_id: INTEGER
		do
			type_id := Eiffel.dynamic_type_from_string (class_name)
			if type_id > 0 and then attached {G} Eiffel.new_instance_of (type_id) as new then
				Result := new
			end
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

	type_alias: FUNCTION [ANY, STRING]
		-- function from `EL_NAMING_ROUTINES' converting type to string

feature -- Element change

	append (type_tuple: TUPLE)
		do
			types_indexed_by_name.accommodate (types_indexed_by_name.count + type_tuple.count)
			new_type_list (type_tuple).do_all (agent extend)
		end

	extend (type: TYPE [G])
		-- extend `types_indexed_by_name' using `type_alias' function
		require
			valid_alias: not type_alias (type).is_empty
		do
			types_indexed_by_name [type_alias (type)] := type
		end

	force (type: TYPE [G]; name: ZSTRING)
		do
			types_indexed_by_name.force (type, name)
		end

	put (type: TYPE [G]; name: ZSTRING)
		do
			types_indexed_by_name.put (type, name)
		end

	set_default_alias (type: TYPE [G])
		do
			default_alias := alias_name (type)
		end

	set_type_alias (a_type_alias: like type_alias)
		do
			type_alias := a_type_alias
		end

feature -- Contract support

	has_alias (a_alias: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := types_indexed_by_name.has (General.to_zstring (a_alias))
		end

	valid_alias (a_alias: READABLE_STRING_GENERAL): BOOLEAN
		do
			if types_indexed_by_name.has_key (General.to_zstring (a_alias)) then
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

	all_aliases_not_empty (a_type_alias: like type_alias; type_tuple: TUPLE): BOOLEAN
		do
			Result := not across new_type_list (type_tuple) as type some a_type_alias (type.item).is_empty end
		end

feature {EL_FACTORY_CLIENT} -- Implementation

	alias_name (type: TYPE [G]): ZSTRING
		-- lower cased type name returned from function `type_alias' function
		do
			Result := type_alias (type)
			Result.to_lower
		end

	alias_words (type: TYPE [G]): ZSTRING
		do
			Result := alias_name (type)
		end

	new_type_list (type_tuple: TUPLE): EL_TUPLE_TYPE_LIST [G]
		do
			create Result.make_from_tuple (type_tuple)
		ensure
			all_conform_to_generic_parameter_G: Result.count = type_tuple.count
		end

feature {NONE} -- Internal attributes

	types_indexed_by_name: EL_ZSTRING_HASH_TABLE [TYPE [G]]
		-- map of alias names to types

feature {NONE} -- Constants

	General: EL_ZSTRING_CONVERTER
		once
			create Result.make
		end

end
