note
	description: "[
		${EL_OBJECT_FACTORY [G]} that can create initialized objects using
		factory conforming to ${EL_FACTORY [G]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "9"

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
			factory_type := {F}
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

	new_factory (factory_type_id: INTEGER): detachable F
		local
			factory_id: INTEGER; target_type: TYPE [ANY]
		do
			target_type := factory_type.generic_parameter_type (1)
			if {ISE_RUNTIME}.type_conforms_to (factory_type_id, target_type.type_id) then
				factory_id := Factory.substituted_type_id (factory_type, target_type, factory_type_id)
				if factory_id >= 0 and then factory_factory.valid_type_id (factory_id) then
					Result := factory_factory.new_item_from_type_id (factory_id)
				end
			end
		end

feature {NONE} -- Internal attributes

	factory_type: TYPE [EL_FACTORY [G]]

	factory_factory: EL_OBJECT_FACTORY [F]

end