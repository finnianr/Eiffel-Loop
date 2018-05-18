note
	description: "Factory for instances of Eiffel classes conforming to parameter G"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-10 19:08:41 GMT (Thursday 10th May 2018)"
	revision: "6"

class
	EL_OBJECT_FACTORY [G]

inherit
	EL_MODULE_EIFFEL
		export
			{NONE} all
		redefine
			default_create
		end

	EL_MODULE_EXCEPTION
		undefine
			default_create
		end

create
	make, make_from_table, default_create

feature {NONE} -- Initialization

	make (a_suffix_word_count: INTEGER; types: ARRAY [TYPE [G]])
			-- Store type MY_USEFUL_CLASS as alias "my useful" with suffix_word_count = 1
		require
			not_types_empty: not types.is_empty
			all_type_names_have_enough_words_in_prefix:
				across types as type all
					(type.item.name.occurrences ('_') + 1) > a_suffix_word_count
				end
		do
			suffix_word_count := a_suffix_word_count
			create types_indexed_by_name.make_equal (types.count)
			across types as type loop
				types_indexed_by_name [alias_name (type.item)] := type.item
			end
			set_default_alias (types [1])
		end

	make_from_table (mapping_table: ARRAY [TUPLE [name: READABLE_STRING_GENERAL; type: TYPE [G]]])
		require
			not_empty: not mapping_table.is_empty
		do
			create types_indexed_by_name.make (mapping_table)
			types_indexed_by_name.compare_objects
			set_default_alias (mapping_table.item (1).type)
		end

	default_create
		do
			create types_indexed_by_name
			types_indexed_by_name.compare_objects
			create default_alias.make_empty
		end

feature -- Factory

	instance_from_alias (type_alias: ZSTRING; initialize: PROCEDURE): G
			--
		require
			has_type: has_type (type_alias)
		do
			Result := raw_instance_from_alias (type_alias)
			initialize (Result)
		end

	instance_from_class_name (class_name: STRING; initialize: PROCEDURE): G
			--
		require
			valid_type: valid_type (class_name)
		do
			Result := instance_from_dynamic_type (Eiffel.dynamic_type_from_string (class_name), initialize)
			if not attached Result then
				Exception.raise_panic ("Class %S is not compiled into system", [class_name])
			end
		end

	instance_from_type (type: TYPE [G]; initialize: PROCEDURE): G
			--
		do
			Result := instance_from_dynamic_type (type.type_id, initialize)
			if not attached Result then
				Exception.raise_panic ("Failed to create instance of class: %S", [type.name])
			end
		end

	raw_instance_from_alias (type_alias: ZSTRING): G
			-- uninitialized instance (useful for obtaining object constants)
		require
			has_type: has_type (type_alias)
		do
			if types_indexed_by_name.has_key (type_alias)
				and then attached {G} Eiffel.new_instance_of (types_indexed_by_name.found_item.type_id) as instance
			then
				Result := instance
			else
				Exception.raise_panic ("Could not instantiate class with alias: %"%S%"", [type_alias])
			end
		end

feature -- Access

	alias_names: EL_ZSTRING_LIST
		do
			create Result.make_from_array (types_indexed_by_name.current_keys)
		end

	alias_name (type: TYPE [G]): ZSTRING
		local
			words: EL_ZSTRING_LIST
			prefix_words: EL_STRING_LIST [ZSTRING]
		do
			create words.make_with_separator (type.name.to_string_8, '_', False)
			prefix_words := words.subchain (1, words.count - suffix_word_count)
			Result := prefix_words.joined_words.as_lower
		end

	suffix_word_count: INTEGER

	default_alias: ZSTRING

feature -- Element change

	set_default_alias (type: TYPE [G])
		do
			default_alias := alias_name (type)
		end

	put (type: TYPE [G]; name: ZSTRING)
		do
			types_indexed_by_name.put (type, name)
		end

feature -- Contract support

	has_type (type_alias: ZSTRING): BOOLEAN
		do
			Result := types_indexed_by_name.has (type_alias)
		end

	valid_type (class_name: ZSTRING): BOOLEAN
		do
			Result := Eiffel.dynamic_type_from_string (class_name) >= 0
		end

feature {EL_FACTORY_CLIENT} -- Implementation

	instance_from_dynamic_type (type_id: INTEGER; initialize: PROCEDURE): G
			--
		do
			if type_id >= 0 and then attached {G} Eiffel.new_instance_of (type_id) as instance then
				initialize (instance)
				Result := instance
			end
		end

	types_indexed_by_name: EL_ZSTRING_HASH_TABLE [TYPE [G]]
		-- map of alias names to types

end
