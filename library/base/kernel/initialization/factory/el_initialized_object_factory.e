note
	description: "[
		An [$source EL_OBJECT_FACTORY [G]] object that creates initialized objects using
		factory conforming to [$source EL_FACTORY [G]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 10:29:39 GMT (Monday 25th December 2023)"
	revision: "5"

class
	EL_INITIALIZED_OBJECT_FACTORY [F -> EL_FACTORY [G], G]

inherit
	EL_OBJECT_FACTORY [G]
		export
			{NONE} all
			{ANY} new_item_from_type, new_item_from_name, valid_type_id, valid_name
		redefine
			default_create, new_item_from_type_id
		end

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create factory_factory
			create factory_table.make (5, agent new_factory)
			parameter_type := ({F}).generic_parameter_type (1)
		end

feature -- Factory

	new_item_factory (type_id: INTEGER): detachable F
		do
			Result := factory_table.item (type_id)
		end

	new_item_from_type_id (type_id: INTEGER): detachable G
		-- new item from dynamic type `type_id'
		require else
			valid_type: is_valid_type (type_id)
		do
			if attached factory_table.item (type_id) as factory then
				Result := factory.new_item
			end
		end

feature -- Status query

	is_valid_type (type_id: INTEGER): BOOLEAN
		do
			Result := {ISE_RUNTIME}.type_conforms_to (type_id, ({G}).type_id)
		end

feature {NONE} -- Implementation

	new_factory_name (type_id: INTEGER): STRING
		do
			Result := Eiffel.substituted_type_name ({F}, parameter_type, Eiffel.type_of_type (type_id))
		end

	new_factory (type_id: INTEGER): detachable F
		local
			factory_name: STRING
		do
			factory_name := new_factory_name (type_id)
			if factory_factory.valid_name (factory_name)
				and then attached factory_factory.new_item_from_name (factory_name) as factory
			then
				Result := factory
			end
		end

feature {NONE} -- Internal attributes

	factory_factory: EL_OBJECT_FACTORY [F]

	factory_table: EL_AGENT_CACHE_TABLE [detachable F, INTEGER]

	parameter_type: TYPE [ANY]

end