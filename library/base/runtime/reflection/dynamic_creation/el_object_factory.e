note
	description: "Factory for instances of Eiffel classes conforming to parameter G"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 10:15:45 GMT (Monday 2nd September 2019)"
	revision: "13"

class
	EL_OBJECT_FACTORY [G]

inherit
	ANY
		redefine
			default_create
		end

	EL_MODULE_EIFFEL

	EL_MODULE_EXCEPTION

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

	make (a_type_alias: like type_alias; types: ARRAY [TYPE [G]])
			-- Store type MY_USEFUL_CLASS as alias "my${separator}useful" with suffix_word_count = 1
		require
			not_types_empty: not types.is_empty
			all_aliases_not_empty: across types as type all not a_type_alias (type.item).is_empty	end
		do
			default_create
			type_alias := a_type_alias
			types_indexed_by_name.accommodate (types.count)
			types.do_all (agent extend)
			set_default_alias (types [1])
		end

	make_from_table (mapping_table: ARRAY [TUPLE [name: READABLE_STRING_GENERAL; type: TYPE [G]]])
		require
			not_empty: not mapping_table.is_empty
		do
			default_create
			types_indexed_by_name.accommodate (mapping_table.count)
			across mapping_table as map loop
				if map.cursor_index = 1 then
					set_default_alias (map.item.type) -- First type
				end
				types_indexed_by_name [Zstring.as_zstring (map.item.name)] := map.item.type
			end
		end

	make_words_lower (a_suffix_word_count: INTEGER; types: ARRAY [TYPE [G]])
		do
			make (agent Naming.class_with_separator_as_lower (?, ' ', 0, a_suffix_word_count), types)
		end

	make_words_upper (a_suffix_word_count: INTEGER; types: ARRAY [TYPE [G]])
		do
			make (agent Naming.class_with_separator (?, ' ', 0, a_suffix_word_count), types)
		end

feature -- Factory

	instance_from_alias (a_alias: READABLE_STRING_GENERAL; initialize: PROCEDURE [G]): G
			-- initialized instance for type corresponding to `type_alias'
			-- or else instance for `default_alias' if `type_alias' cannot be found
		do
			Result := raw_instance_from_alias (a_alias)
			initialize (Result)
		end

	instance_from_class_name (class_name: STRING; initialize: PROCEDURE [G]): G
			--
		require
			valid_type: valid_type (class_name)
		do
			Result := instance_from_dynamic_type (Eiffel.dynamic_type_from_string (class_name), initialize)
			if not attached Result then
				Exception.raise_panic (Template_not_compiled, [class_name])
			end
		end

	instance_from_type (type: TYPE [G]; initialize: PROCEDURE [G]): G
			-- initialized instance of type
		do
			Result := instance_from_dynamic_type (type.type_id, initialize)
			if not attached Result then
				Exception.raise_panic ("Failed to create instance of class: %S", [type.name])
			end
		end

	raw_instance_from_alias (a_alias: READABLE_STRING_GENERAL): G
			-- uninitialized instance for type corresponding to `type_alias'
			-- or else instance for `default_alias' if `type_alias' cannot be found
		do
			if types_indexed_by_name.has_key (General.to_zstring (a_alias)) then
				if attached {G} Eiffel.new_instance_of (types_indexed_by_name.found_item.type_id) as instance then
					Result := instance
				end
			elseif not default_alias.is_empty then
				Result := raw_instance_from_alias (default_alias)
			end
			if not attached Result then
				Exception.raise_panic ("Could not instantiate class with alias: %"%S%"", [a_alias])
			end
		end

	raw_instance_from_class_name (class_name: STRING): G
			--
		require
			valid_type: valid_type (class_name)
		local
			type_id: INTEGER
		do
			type_id := Eiffel.dynamic_type_from_string (class_name)
			if type_id > 0 and then attached {G} Eiffel.new_instance_of (type_id) as instance then
				Result := instance
			else
				Exception.raise_panic (Template_not_compiled, [class_name])
			end
		end

feature -- Access

	alias_names: EL_ZSTRING_LIST
		do
			create Result.make_from_array (types_indexed_by_name.current_keys)
		end

	default_alias: ZSTRING

	type_alias: FUNCTION [ANY, STRING]
		-- function from `EL_NAMING_ROUTINES' converting type to string

feature -- Element change

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

	valid_type (class_name: STRING): BOOLEAN
		do
			Result := Eiffel.dynamic_type_from_string (class_name) >= 0
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

	instance_from_dynamic_type (type_id: INTEGER; initialize: PROCEDURE [G]): G
			--
		do
			if type_id >= 0 and then attached {G} Eiffel.new_instance_of (type_id) as instance then
				initialize (instance)
				Result := instance
			end
		end

	types_indexed_by_name: EL_ZSTRING_HASH_TABLE [TYPE [G]]
		-- map of alias names to types

feature {NONE} -- Constants

	General: EL_ZSTRING_CONVERTER
		once
			create Result.make
		end

	Template_not_compiled: ZSTRING
		once
			Result := "Class %S is not compiled into system"
		end

end
