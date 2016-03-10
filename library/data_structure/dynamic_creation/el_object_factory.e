note
	description: "Summary description for {EL_OBJECT_FACTORY_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-24 15:19:11 GMT (Wednesday 24th July 2013)"
	revision: "3"

class
	EL_OBJECT_FACTORY [G]

inherit
	EL_MODULE_TYPING
		export
			{NONE} all
		redefine
			default_create
		end

create
	make, make_from_table, default_create

feature {NONE} -- Initialization

	make (a_suffix_word_count: INTEGER; types: ARRAY [TYPE [G]])
			-- Store type MY_USEFUL_CLASS as alias "my useful" with suffix_word_count = 1
		require all_type_names_have_enough_words_in_prefix:
			across types as type all
				(type.item.name.occurrences ('_') + 1) > a_suffix_word_count
			end
		do
			suffix_word_count := a_suffix_word_count
			create alias_map.make_equal (types.count)
			across types as type loop
				alias_map [alias_name (type.item)] := type.item
			end
			set_default_alias (types [1])
		end

	make_from_table (mapping_table: ARRAY [TUPLE [name: READABLE_STRING_GENERAL; type: TYPE [G]]])
		do
			create alias_map.make (mapping_table)
			alias_map.compare_objects
			set_default_alias (mapping_table.item (1).type)
		end

	default_create
		do
			create alias_map
			alias_map.compare_objects
			create default_alias.make_empty
		end

feature -- Factory

	instance_from_alias (type_alias: EL_ASTRING; constructor: PROCEDURE [G, TUPLE]): G
			--
		require
			has_type: has_type (type_alias)
		do
			Result := raw_instance_from_alias (type_alias)
			constructor.call ([Result])
		end

	instance_from_class_name (class_name: EL_ASTRING; constructor: PROCEDURE [G, TUPLE]): G
			--
		require
			valid_type: valid_type (class_name)
		do
			Result := instance_from_type_id (Typing.dynamic_type_from_string (class_name.to_unicode), constructor)
		end

	raw_instance_from_alias (type_alias: EL_ASTRING): G
			-- uninitialized instance (useful for obtaining object constants)
		require
			has_type: has_type (type_alias)
		do
			alias_map.search (type_alias)
			if alias_map.found and then attached {G} Typing.new_instance_of (alias_map.found_item.type_id) as l_result then
				Result := l_result
			end
		end

feature -- Access

	alias_names: ARRAYED_LIST [EL_ASTRING]
		local
			l_sorted: SORTABLE_ARRAY [EL_ASTRING]
		do
			create l_sorted.make_from_array (alias_map.current_keys)
			l_sorted.compare_objects
			l_sorted.sort
			create Result.make_from_array (l_sorted)
			Result.compare_objects
		end

	alias_name (type: TYPE [G]): EL_ASTRING
		local
			words: EL_ASTRING_LIST
			prefix_words: EL_STRING_LIST [EL_ASTRING]
		do
			create words.make_with_separator (type.name.to_string_8, '_', False)
			prefix_words := words.subchain (1, words.count - suffix_word_count)
			Result := prefix_words.joined_words.as_lower
		end

	suffix_word_count: INTEGER

	default_alias: EL_ASTRING

feature -- Element change

	set_default_alias (type: TYPE [G])
		do
			default_alias := alias_name (type)
		end

feature -- Contract support

	has_type (type_alias: EL_ASTRING): BOOLEAN
		do
			Result := alias_map.has (type_alias)
		end

	valid_type (class_name: EL_ASTRING): BOOLEAN
		do
			Result := Typing.dynamic_type_from_string (class_name) > 0
		end

feature {NONE} -- Implementation

	instance_from_type_id (type_id: INTEGER; constructor: PROCEDURE [G, TUPLE]): G
			--
		require
			valid_type: type_id > 0
		do
			if type_id > 0 and then attached {G} Typing.new_instance_of (type_id) as instance then
				constructor.call ([instance])
				Result := instance
			end
		end

	alias_map: EL_ASTRING_HASH_TABLE [TYPE [G]]
		-- map of alias names to types

end
