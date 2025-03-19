note
	description: "Class reflective meta data"
	descendants: "[
			EL_CLASS_META_DATA
				${EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-15 10:57:52 GMT (Saturday 15th March 2025)"
	revision: "83"

class
	EL_CLASS_META_DATA

inherit
	EL_LAZY_ATTRIBUTE
		rename
			new_item as new_alphabetical_list,
			cached_item as actual_alphabetical_list
		end

	EL_MODULE_EIFFEL; EL_MODULE_NAMING

	EL_REFLECTION_CONSTANTS

	EL_STRING_8_CONSTANTS

	EL_REFLECTION_HANDLER

	EL_SHARED_NEW_INSTANCE_TABLE; EL_SHARED_READER_WRITER_TABLE

	EL_SHARED_CLASS_ID; EL_SHARED_FACTORIES; EL_SHARED_IMMUTABLE_8_MANAGER

create
	make

feature {NONE} -- Initialization

	make (a_target: like target)
		do
			target := a_target
			field_info_table := a_target.field_info_table

			New_instance_table.extend_from_list (a_target.new_instance_functions)
			Reader_writer_table.merge (a_target.new_extra_reader_writer_table)

			tuple_field_table := a_target.new_tuple_field_table

			field_list := new_field_list
			if attached a_target.foreign_naming as translater then
				field_list.set_export_names (translater)
			end
			field_table := field_list.to_table (a_target)

			field_printer := a_target.new_field_printer
			if attached field_indices_subset (field_printer.hidden_fields) as hidden_fields then
				field_printer.set_displayable_fields (field_table.new_field_subset (hidden_fields))
			end

			if attached a_target.foreign_naming as foreign_naming then
				across field_table as table loop
					foreign_naming.inform (table.key)
				end
			end
			across target.new_representations as representation loop
				if field_table.has_key (representation.key) then
					field_table.found_item.set_representation (representation.item)
				end
			end
		ensure then
			same_order: across field_table as table all
				table.key.is_equal (field_list.i_th (table.cursor_index).name)
			end
		end

feature -- Access

	alphabetical_list: like new_alphabetical_list
		do
			Result := lazy_item
		end

	field_indices_subset (name_list: STRING): EL_FIELD_INDICES_SET
		do
			Result := field_info_table.field_indices_subset (name_list)
		end

	field_printer: EL_REFLECTIVE_CONSOLE_PRINTER

	target: EL_REFLECTIVE
		-- reflective target object

	field_list: EL_FIELD_LIST

	field_table: EL_FIELD_TABLE

feature -- Status query

	same_data_structure (a_field_hash: NATURAL): BOOLEAN
		-- `True' if order, type and names of fields are unchanged
		do
			Result := field_list.field_hash = a_field_hash
		end

	same_fields (a_current, other: EL_REFLECTIVE; name_list: STRING): BOOLEAN
		-- `True' if all fields in `name_list' have same value
		do
			Result := True
			if attached field_indices_subset (name_list) as field_set and then attached field_list as list then
				from list.start until not Result or list.after loop
					if field_set.has (list.item.index) then
						Result := list.item.are_equal (a_current, other)
					end
					list.forth
				end
			end
		end

feature -- Comparison

	all_fields_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		local
			i, count: INTEGER
		do
			if attached field_list as list then
				count := list.count
				Result := True
				from i := 1 until not Result or i > count loop
					Result := list [i].are_equal (a_current, other)
					i := i + 1
				end
			end
		end

feature {NONE} -- Factory

	new_alphabetical_list: EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		-- fields sorted alphabetically
		do
			Result := field_list.ordered_by (agent {EL_REFLECTED_FIELD}.name, True)
		end

	new_expanded_field (index: INTEGER; name: IMMUTABLE_STRING_8): EL_REFLECTED_FIELD
		-- have not worked out how to deal with this
		require
			never_called: False
		do
			create {EL_REFLECTED_REFERENCE_ANY} Result.make (target, index, name)
		end

	new_field_list: EL_FIELD_LIST
		-- list of field names with empty strings in place of excluded fields
		do
			if attached field_info_table.new_not_transient_subset (target.new_transient_fields) as name_list then
				create Result.make (name_list.count)
				across name_list as list loop
					if field_info_table.has_immutable_key (list.item)
						and then attached field_info_table.found_type_info as field
						and then target.field_included (field)
					then
						Result.extend (new_reflected_field (field, list.item))
					end
				end
				Result.set_order (target.new_field_sorter, field_info_table)
			else
				create Result.make (0)
			end
		end

	new_reference_field (field: EL_FIELD_TYPE_PROPERTIES; name: IMMUTABLE_STRING_8): EL_REFLECTED_FIELD
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

			elseif field.conforms_to (Class_id.EL_SUBSTRING__STRING_GENERAL) then
				create {EL_REFLECTED_SUBSTRING} Result.make (target, index, name)
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

	new_reflected_field (field: EL_FIELD_TYPE_PROPERTIES; name: IMMUTABLE_STRING_8): EL_REFLECTED_FIELD
		do
			inspect field.abstract_type
				when Reference_type then
					Result := new_reference_field (field, name)

				when Expanded_type then
					Result := new_expanded_field (field.index, name)

			else
				if attached Standard_field_types [field.abstract_type] as field_type then
					Result := Field_factory.new_item (field_type, target, field.index, name)
				end
			end
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

feature {EL_REFLECTION_HANDLER} -- Internal attributes

	tuple_field_table: EL_TUPLE_FIELD_TABLE

	field_info_table: EL_OBJECT_FIELDS_TABLE
		-- complete table of object field indices by name

feature {NONE} -- Constants

	Field_factory: EL_INITIALIZED_FIELD_FACTORY
		once
			create Result
		end

	Reference_group_table: EL_FUNCTION_GROUPED_SET_TABLE [EL_REFLECTED_REFERENCE [ANY], TYPE [ANY]]
		once
			Result := new_reference_group_table
		end

end