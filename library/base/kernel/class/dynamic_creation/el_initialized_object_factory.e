note
	description: "[
		An [$source EL_OBJECT_FACTORY [G]] object that creates initialized objects using
		factory conforming to [$source EL_FACTORY [G]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-06 18:44:29 GMT (Tuesday 6th December 2022)"
	revision: "1"

class
	EL_INITIALIZED_OBJECT_FACTORY [F -> EL_FACTORY [G], G]

inherit
	EL_OBJECT_FACTORY [G]
		export
			{NONE} all
			{ANY} new_item_from_type, valid_type_id
		redefine
			default_create, new_item_from_type_id
		end

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create factory_factory
			create factory_table.make (5, agent new_factory)
			template := ({F}).name
			template.remove_substring (template.index_of ('[', 1) + 1, template.count - 1)
		ensure then
			valid_template: template.ends_with ("[]")
		end

feature -- Factory

	new_item_from_type_id (type_id: INTEGER): detachable G
		-- new item from dynamic type `type_id'
		do
			if attached factory_table.item (type_id) as factory then
				Result := factory.new_item
			end
		end

feature {NONE} -- Implementation

	new_factory (type_id: INTEGER): detachable F
		local
			factory_name: STRING
		do
			factory_name := template.twin
			factory_name.insert_string (Eiffel.type_name_of_type (type_id), factory_name.count)
			if attached factory_factory.new_item_from_name (factory_name) as factory then
				Result := factory
			end
		end

feature {NONE} -- Internal attributes

	template: STRING

	factory_factory: EL_OBJECT_FACTORY [F]

	factory_table: EL_CACHE_TABLE [detachable F, INTEGER]

end