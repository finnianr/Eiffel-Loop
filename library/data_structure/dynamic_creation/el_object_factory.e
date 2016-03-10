note
	description: "Summary description for {EL_OBJECT_FACTORY_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-15 18:07:03 GMT (Wednesday 15th January 2014)"
	revision: "4"

class
	EL_OBJECT_FACTORY [G]

inherit
	EL_MODULE_EIFFEL
		export
			{NONE} all
		redefine
			default_create
		end

	EL_MODULE_STRING
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

	instance_from_alias (type_alias: ASTRING; constructor: PROCEDURE [G, TUPLE]): G
			--
		require
			has_type: has_type (type_alias)
		do
			Result := raw_instance_from_alias (type_alias)
			constructor.call ([Result])
		end

	instance_from_class_name (class_name: ASTRING; constructor: PROCEDURE [G, TUPLE]): G
			--
		require
			valid_type: valid_type (class_name)
		local
			type_id: INTEGER; exception: EIFFEL_RUNTIME_PANIC
			template: ASTRING
		do
			type_id := Eiffel.dynamic_type_from_string (class_name.to_unicode)
			if type_id > 0 and then attached {G} Eiffel.new_instance_of (type_id) as instance then
				constructor.call ([instance])
				Result := instance
			else
				template := once "Class $S is not compiled into system"
				create exception
				exception.set_description (template #$ [class_name])
				exception.raise
			end
		end

	raw_instance_from_alias (type_alias: ASTRING): G
			-- uninitialized instance (useful for obtaining object constants)
		require
			has_type: has_type (type_alias)
		local
			exception: EIFFEL_RUNTIME_PANIC
		do
			types_indexed_by_name.search (type_alias)
			if types_indexed_by_name.found and then attached {G} Eiffel.new_instance_of (types_indexed_by_name.found_item.type_id) as l_result then
				Result := l_result
			else
				create exception
				exception.set_description ("Could not instantiate class with alias %"$S%": " + type_alias.to_string_8)
				exception.raise
			end
		end

feature -- Access

	alias_names: EL_ASTRING_LIST
		do
			create Result.make_from_array (types_indexed_by_name.current_keys)
		end

	alias_name (type: TYPE [G]): ASTRING
		local
			words: EL_ASTRING_LIST
			prefix_words: EL_STRING_LIST [ASTRING]
		do
			create words.make_with_separator (type.name.to_string_8, '_', False)
			prefix_words := words.subchain (1, words.count - suffix_word_count)
			Result := prefix_words.joined_words.as_lower
		end

	suffix_word_count: INTEGER

	default_alias: ASTRING

feature -- Element change

	set_default_alias (type: TYPE [G])
		do
			default_alias := alias_name (type)
		end

	put (type: TYPE [G]; name: ASTRING)
		do
			types_indexed_by_name.put (type, name)
		end

feature -- Contract support

	has_type (type_alias: ASTRING): BOOLEAN
		do
			Result := types_indexed_by_name.has (type_alias)
		end

	valid_type (class_name: ASTRING): BOOLEAN
		do
			Result := Eiffel.dynamic_type_from_string (class_name) > 0
		end

feature {EL_FACTORY_CLIENT} -- Implementation

	types_indexed_by_name: EL_ASTRING_HASH_TABLE [TYPE [G]]
		-- map of alias names to types

end
