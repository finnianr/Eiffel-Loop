note
	description: "[
		${EL_OBJECT_FACTORY [G]} that can create initialized objects using
		factory conforming to ${EL_FACTORY [G]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-04 17:14:09 GMT (Wednesday 4th September 2024)"
	revision: "12"

class
	EL_INITIALIZED_OBJECT_FACTORY [F -> EL_FACTORY [G], G]

inherit
	EL_OBJECT_FACTORY [G]
		export
			{NONE} all
			{ANY} new_item_from_type, new_item_from_name, valid_type_id, valid_name
		undefine
			copy, is_equal
		redefine
			default_create, new_item_from_type_id
		end

	EL_CACHE_TABLE [detachable F, INTEGER]
		rename
			force as force_factory,
			put as put_factory,
			item as new_item_factory,
			new_item as new_factory,
			make as make_cache,
			count as cached_count
		export
			{NONE} all
			{ANY} new_item_factory
		undefine
			default_create
		end

	EL_MODULE_FACTORY

feature {NONE} -- Initialization

	default_create
		do
			Precursor {EL_OBJECT_FACTORY}
			make_cache (5)
			create factory_factory
			create generic_type_factory_cache.make (11)
			factory_type := {F}
			base_type := {G}
		end

feature -- Factory

	new_item_from_type_id (type_id: INTEGER): detachable G
		-- new item from dynamic type `type_id'
		require else
			valid_type: is_valid_type (type_id)
		do
			if attached new_item_factory (type_id) as factory_item then
				Result := factory_item.new_item
			end
		end

feature -- Status query

	is_valid_type (type_id: INTEGER): BOOLEAN
		do
			Result := {ISE_RUNTIME}.type_conforms_to (type_id, ({G}).type_id)
		end

feature {NONE} -- Implementation

	new_generic_type_factory (a_base_type: TYPE [ANY]; parameter_types: ARRAY [TYPE [ANY]]): detachable F
		-- factory for generic `a_base_type' class with generic parameters `parameter_types'
		local
			i, type_id: INTEGER; type_array: SPECIAL [INTEGER]
		do
			create type_array.make_empty (parameter_types.count)
			from i := 1 until i > parameter_types.count loop
				type_array.extend (parameter_types [i].type_id)
				i := i + 1
			end
			if generic_type_factory_cache.has_hashed_key (a_base_type.type_id, type_array) then
				Result := generic_type_factory_cache.found_item
			else
				type_id := Factory.parameterized_type_id (a_base_type, parameter_types)
				if attached new_item_factory (type_id) as new_item then
					Result := new_item
					generic_type_factory_cache.extend (new_item, generic_type_factory_cache.last_key)
				end
			end
		end

	new_factory (target_type_id: INTEGER): detachable F
		-- factory to create target type with `target_type_id'
		local
			factory_id: INTEGER
		do
			if {ISE_RUNTIME}.type_conforms_to (target_type_id, base_type.type_id) then
				factory_id := Factory.substituted_type_id (factory_type, base_type, target_type_id)

				if factory_id >= 0 and then factory_factory.valid_type_id (factory_id) then
					Result := factory_factory.new_item_from_type_id (factory_id)
				end
			end
		end

feature {NONE} -- Internal attributes

	generic_type_factory_cache: EL_INTEGER_ARRAY_KEY_TABLE [F]

	factory_factory: EL_OBJECT_FACTORY [F]

	factory_type: TYPE [EL_FACTORY [G]]

	base_type: TYPE [ANY]
		-- target base type of `G'

end