note
	description: "[
		Factory to create class instances conforming to parameter `G' and contained in set of types defined by
		`TYPE_SET' parameter, and also including the default type `DEFAULT'.
	]"
	notes: "[
		The `type_alias' function converts the target types defined by `TYPE_SET' into a string.
		Typically it will use a routine from [$source EL_NAMING_ROUTINES] (accessible via [$source EL_MODULE_NAMING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-02 11:59:55 GMT (Monday 2nd November 2020)"
	revision: "1"

class
	EL_CLASS_SET_FACTORY [G, DEFAULT -> G, TYPE_SET -> TUPLE create default_create end]

inherit
	EL_OBJECT_FACTORY [G]
		rename
			make as make_factory
		redefine
			default_create
		end

	EL_MODULE_NAMING

create
	make, make_words_lower, make_words_upper

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			type_alias := agent Naming.class_with_separator_as_lower (?, ' ', 0, 0)
		end

	make (a_type_alias: like type_alias)
		require
			all_aliases_not_empty: all_aliases_not_empty (a_type_alias)
		local
			type_set: TYPE_SET
		do
			default_create
			create type_set
			type_alias := a_type_alias
			types_indexed_by_name.accommodate (type_set.count + 1)
			extend ({DEFAULT})
			set_default_alias ({DEFAULT})

			across new_type_list (type_set) as type loop
				extend (type.item)
			end
		end

	make_words_lower (suffix_word_count: INTEGER)
		-- make lowercase aliases by stripping `suffix_word_count' words from the type name
		-- and converting underscores to spaces
		do
			make (agent Naming.class_with_separator_as_lower (?, ' ', 0, suffix_word_count))
		end

	make_words_upper (suffix_word_count: INTEGER)
		-- make uppercase aliases by stripping `suffix_word_count' words from the type name
		-- and converting underscores to spaces
		do
			make (agent Naming.class_with_separator (?, ' ', 0, suffix_word_count))
		end

feature -- Access

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

	set_default_alias (type: TYPE [G])
		do
			default_alias := alias_name (type)
		end

	set_type_alias (a_type_alias: like type_alias)
		do
			type_alias := a_type_alias
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

feature -- Contract support

	all_aliases_not_empty (a_type_alias: like type_alias): BOOLEAN
		local
			type_set: TYPE_SET
		do
			create type_set
			Result := across new_type_list (type_set) as type all a_type_alias (type.item).count > 0 end
		end

feature {NONE} -- Implementation

	new_type_list (type_tuple: TUPLE): EL_TUPLE_TYPE_LIST [G]
		do
			create Result.make_from_tuple (type_tuple)
		ensure
			all_conform_to_generic_parameter_G: Result.count = type_tuple.count
		end

end