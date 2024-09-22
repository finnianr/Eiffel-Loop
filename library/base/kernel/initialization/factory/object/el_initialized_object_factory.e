note
	description: "[
		${EL_OBJECT_FACTORY [G]} that can create initialized objects using
		factory conforming to ${EL_FACTORY [G]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:38:07 GMT (Sunday 22nd September 2024)"
	revision: "14"

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

	EL_HASH_TABLE [F, NATURAL_64]
		rename
			make as make_sized,
			count as cached_count,
			extend as cached_extend,
			force as cached_force,
			found_item as found_factory,
			has_key as has_factory_key,
			put as cached_put
		export
			{NONE} all
		undefine
			default_create
		end

	EL_MODULE_FACTORY

feature {NONE} -- Initialization

	default_create
		do
			Precursor {EL_OBJECT_FACTORY}
			create factory_factory
			make_sized (11)
			factory_type := {F}
			base_type := factory_type.generic_parameter_type (1)
			create single_type.make_filled (0, 1)
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

	new_item_factory (target_type_id: INTEGER): detachable F
		-- factory to create target type with `target_type_id'
		local
			factory_id: INTEGER; math: EL_INTEGER_MATH; hash_key: NATURAL_64
		do
			single_type [0] := target_type_id
			hash_key := math.hash_key (factory_type.type_id, single_type)

			if has_factory_key (hash_key) then
				Result := found_factory

			elseif {ISE_RUNTIME}.type_conforms_to (target_type_id, base_type.type_id) then
				factory_id := Factory.substituted_type_id (factory_type, base_type, target_type_id)
				if factory_id >= 0 and then factory_factory.valid_type_id (factory_id) then
					Result := factory_factory.new_item_from_type_id (factory_id)
					cached_extend (Result, hash_key)
				end
			else
				check
					target_conforms_to_base: False
				end
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
			type_id: INTEGER; hash_key: NATURAL_64
		do
			hash_key := Factory.type_hash_key (a_base_type, parameter_types)
			if has_factory_key (hash_key) then
				Result := found_factory
			else
				type_id := Factory.parameterized_type_id (a_base_type, parameter_types)
				if attached new_item_factory (type_id) as new_item then
					Result := new_item
					cached_extend (new_item, hash_key)
				end
			end
		end

feature {NONE} -- Internal attributes

	factory_factory: EL_OBJECT_FACTORY [F]

	factory_type: TYPE [EL_FACTORY [G]]

	single_type: SPECIAL [INTEGER]

	base_type: TYPE [ANY]

end