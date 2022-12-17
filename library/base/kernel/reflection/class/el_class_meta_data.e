note
	description: "Class reflective meta data"
	descendants: "[
			EL_CLASS_META_DATA
				[$source EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-17 9:04:37 GMT (Saturday 17th December 2022)"
	revision: "63"

class
	EL_CLASS_META_DATA

inherit
	REFLECTED_REFERENCE_OBJECT
		export
			{NONE} all
		redefine
			make, enclosing_object
		end

	EL_LAZY_ATTRIBUTE
		rename
			item as alphabetical_list,
			new_item as new_alphabetical_list,
			actual_item as actual_alphabetical_list
		end

	EL_MODULE_EIFFEL; EL_MODULE_NAMING; EL_MODULE_REUSEABLE

	EL_REFLECTION_CONSTANTS

	EL_REFLECTION_HANDLER

	EL_SHARED_NEW_INSTANCE_TABLE; EL_SHARED_READER_WRITER_TABLE

	EL_SHARED_CLASS_ID; EL_SHARED_FACTORIES

create
	make

feature {NONE} -- Initialization

	make (a_enclosing_object: like enclosing_object)
		do
			Precursor (a_enclosing_object)

			New_instance_table.extend_from_list (a_enclosing_object.new_instance_functions)
			Reader_writer_table.merge (a_enclosing_object.new_extra_reader_writer_table)
			create cached_field_indices_set.make_equal (3, agent new_field_indices_set)

			field_list := new_field_list
			field_table := field_list.to_table (a_enclosing_object)
			if attached a_enclosing_object.foreign_naming as foreign_naming then
				across field_table as table loop
					foreign_naming.inform (table.key)
				end
			end
			across enclosing_object.new_representations as representation loop
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

	cached_field_indices_set: EL_CACHE_TABLE [EL_FIELD_INDICES_SET, STRING]

	enclosing_object: EL_REFLECTIVE

	field_list: EL_REFLECTED_FIELD_LIST

	field_table: EL_REFLECTED_FIELD_TABLE

feature -- Basic operations

	print_fields (a_object: EL_REFLECTIVE; a_lio: EL_LOGGABLE)
		local
			line_length: INTEGER_REF
		do
			create line_length
			if attached cached_field_indices_set.item (enclosing_object.Hidden_fields) as hidden then
				across field_list as list loop
					if not hidden.has (list.item.index) then
						print_field_value (a_object, list.item, line_length, a_lio)
					end
				end
			end
			a_lio.put_new_line
		end

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
			if attached cached_field_indices_set.item (name_list) as field_set and then attached field_list as list then
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

	new_expanded_field (index: INTEGER; name: STRING): EL_REFLECTED_FIELD
		-- have not worked out how to deal with this
		require
			never_called: False
		do
			create {EL_REFLECTED_REFERENCE_ANY} Result.make (enclosing_object, index, name)
		end

	new_field_indices_set (field_names: detachable STRING): EL_FIELD_INDICES_SET
		do
			if field_names.is_empty then
				Result := Empty_field_indices_set
			else
				create Result.make (Current, field_names)
			end
		end

	new_field_list: EL_REFLECTED_FIELD_LIST
		-- list of field names with empty strings in place of excluded fields
		local
			i, count: INTEGER; excluded_fields: EL_FIELD_INDICES_SET
		do
			excluded_fields := new_field_indices_set (enclosing_object.Transient_fields)
			count := field_count
			create Result.make (count - excluded_fields.count)
			from i := 1 until i > count loop
				if not (is_field_transient (i) or else excluded_fields.has (i))
					and then enclosing_object.field_included (field_type (i), field_static_type (i))
				then
					if attached field_name (i) as name and then not is_once_object (name) then
						-- remove underscore used to distinguish field name from keyword
						name.prune_all_trailing ('_')
						Result.extend (new_reflected_field (i, name))
					end
				end
				i := i + 1
			end
			Result.set_order (Current)
		end

	new_reference_field (index: INTEGER; name: STRING): EL_REFLECTED_FIELD
		local
			type_id: INTEGER
		do
			type_id := field_static_type (index)
			if Non_abstract_field_type_table.has_key (type_id) then
				Result := Field_factory.new_item (Non_abstract_field_type_table.found_item, enclosing_object, index, name)

			elseif attached matched_field_type (type_id) as matched_type then
				Result := Field_factory.new_item (matched_type, enclosing_object, index, name)

			elseif attached matched_collection_factory (type_id) as collection then
				Result := collection.new_field (enclosing_object, index, name)
			else
				create {EL_REFLECTED_REFERENCE_ANY} Result.make (enclosing_object, index, name)
			end
		end

	new_reference_group_table: like Reference_group_table
		do
			extend_field_types (Reference_field_list)
			extend_group_ordering (Group_type_order_table)

			Reference_field_list.order_by (agent group_type_order, True)
			create Result.make_from_list (agent {EL_REFLECTED_REFERENCE [ANY]}.group_type, Reference_field_list)
		end

	new_reflected_field (index: INTEGER; name: STRING): EL_REFLECTED_FIELD
		local
			type: INTEGER
		do
			type := field_type (index)
			inspect type
				when Reference_type then
					Result := new_reference_field (index, name)

				when Expanded_type then
					Result := new_expanded_field (index, name)
			else
				Result := Field_factory.new_item (Standard_field_types [type], enclosing_object, index, name)
			end
		end

feature {NONE} -- Implementation

	extend_group_ordering (order_table: like Group_type_order_table)
		-- for use in descendants as once routine
		do
		end

	extend_field_types (a_field_list: like Reference_field_list)
		-- add extra field types defined in `extra_field_types'
		-- for use in descendants as once routine
		do
		end

	is_once_object (name: STRING): BOOLEAN
		-- `True' if `name' is a once ("OBJECT") field name
		do
			Result := name.count > 0 and then name [1] = '_'
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
			if {ISE_RUNTIME}.type_conforms_to (type_id, Class_id.COLLECTION_ANY) then
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

	print_field_value (a_object: EL_REFLECTIVE; a_field: EL_REFLECTED_FIELD; line_length: INTEGER_REF; a_lio: EL_LOGGABLE)
		local
			length: INTEGER; value: ZSTRING; exceeded_maximum: BOOLEAN
		do
			if attached {EL_REFLECTED_COLLECTION [ANY]} a_field as collection
				and then {ISE_RUNTIME}.type_conforms_to (collection.item_type_id, Class_id.EL_REFLECTIVE)
			then
				line_length.set_item (0)
				a_lio.put_new_line
				collection.print_items (a_object, a_lio)
			else
				across Reuseable.string as reuse loop
					value := reuse.item
					a_field.append_to_string (a_object, value)
					length := a_field.name.count + value.count + 2
					if line_length.item > 0 then
						exceeded_maximum := line_length.item + length > Info_line_length
						if not exceeded_maximum then
							a_lio.put_character (';'); a_lio.put_character (' ')
						end
						if exceeded_maximum then
							a_lio.put_new_line
							line_length.set_item (0)
						end
					end
					a_lio.put_labeled_string (a_field.name, value)
					line_length.set_item (line_length.item + length)
				end
			end
		end

feature {NONE} -- Constants

	Empty_field_indices_set: EL_FIELD_INDICES_SET
		once
			create Result.make_empty
		end


	Field_factory: EL_INITIALIZED_FIELD_FACTORY
		once
			create Result
		end

	Info_line_length: INTEGER
		once
			Result := 100
		end

	Reference_group_table: EL_FUNCTION_GROUP_TABLE [EL_REFLECTED_REFERENCE [ANY], TYPE [ANY]]
		once
			Result := new_reference_group_table
		end

end