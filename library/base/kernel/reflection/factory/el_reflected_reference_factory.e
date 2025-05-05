note
	description: "Reflected reference factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 7:17:15 GMT (Monday 5th May 2025)"
	revision: "1"

deferred class
	EL_REFLECTED_REFERENCE_FACTORY

inherit
	EL_MODULE_EIFFEL

	EL_REFLECTION_CONSTANTS

	EL_SHARED_CLASS_ID

feature {NONE} -- Factory

	new_reference_field (target: ANY; field: EL_FIELD_TYPE_PROPERTIES; name: IMMUTABLE_STRING_8): EL_REFLECTED_FIELD
		local
			type_id, index: INTEGER
		do
			type_id := field.static_type; index := field.index
			if Non_abstract_field_type_table.has_key (type_id) then
				Result := Field_factory.new_item (Non_abstract_field_type_table.found_item, target, index, name)

			elseif attached matched_field_type (type_id) as matched_type then
				Result := Field_factory.new_item (matched_type, target, index, name)

			elseif attached matched_collection_factory (type_id) as collection then
				Result := collection.new_field (target, index, name)

			elseif field.is_manifest_substring then
				create {EL_REFLECTED_MANIFEST_SUBSTRING} Result.make (target, index, name)
			else
				create {EL_REFLECTED_REFERENCE_ANY} Result.make (target, index, name)
			end
			if attached {EL_REFLECTED_TUPLE} Result as tuple then
				tuple_field_table.initialize_field (tuple)
			end
		end

	new_reference_group_table: like Reference_group_table
		do
			extend_field_types (Reference_field_list)
			extend_group_ordering (Group_type_order_table)

			Reference_field_list.order_by (agent group_type_order, True)
			create Result.make_equal_from_list (agent {EL_REFLECTED_REFERENCE [ANY]}.group_type, Reference_field_list)
		end

feature {NONE} -- Implementation

	extend_field_types (a_field_list: like Reference_field_list)
		-- add extra field types defined in `extra_field_types'
		-- for use in descendants as once routine
		do
		end

	extend_group_ordering (order_table: like Group_type_order_table)
		-- for use in descendants as once routine
		do
		end

	group_type_order (a_field: EL_REFLECTED_REFERENCE [ANY]): REAL
		-- search order for matching value_type
		do
			if Group_type_order_table.has_key (a_field.group_type)  then
				Result := Group_type_order_table.found_item
			end
		end

	matched_collection_factory (type_id: INTEGER): detachable like Collection_field_factory_factory.new_item_factory
		local
			item_type_id: INTEGER
		do
			if {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.COLLECTION__ANY) then
				item_type_id := Eiffel.collection_item_type (type_id)
				if item_type_id > 0 then
					Result := Collection_field_factory_factory.new_item_factory (item_type_id)
				end
			end
		end

	matched_field_type (type_id: INTEGER): detachable TYPE [EL_REFLECTED_REFERENCE [ANY]]
		do
			across Reference_group_table as table until attached Result loop
				if {ISE_RUNTIME}.type_conforms_to (type_id, table.key.type_id) then
					across table.item as group until attached Result loop
						if {ISE_RUNTIME}.type_conforms_to (type_id, group.item.value_type.type_id) then
							Result := group.item.generating_type
						end
					end
				end
			end
		end

	tuple_field_table: EL_TUPLE_FIELD_TABLE
		do
			create Result.make_empty
		end

feature {NONE} -- Constants

	Field_factory: EL_INITIALIZED_FIELD_FACTORY
		once
			create Result
		end

feature {NONE} -- Constants

	Reference_group_table: EL_FUNCTION_GROUPED_SET_TABLE [EL_REFLECTED_REFERENCE [ANY], TYPE [ANY]]
		once
			Result := new_reference_group_table
		end

end