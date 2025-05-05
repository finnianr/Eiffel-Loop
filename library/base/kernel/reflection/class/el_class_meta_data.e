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
	date: "2025-05-05 7:24:56 GMT (Monday 5th May 2025)"
	revision: "88"

class
	EL_CLASS_META_DATA

inherit
	EL_LAZY_ATTRIBUTE
		rename
			new_item as new_alphabetical_list,
			cached_item as actual_alphabetical_list
		end

	EL_REFLECTED_REFERENCE_FACTORY
		redefine
			tuple_field_table
		end

	EL_REFLECTION_HANDLER

	EL_SHARED_NEW_INSTANCE_TABLE; EL_SHARED_READER_WRITER_TABLE

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

			create field_list.make (Current)

			field_printer := a_target.new_field_printer
			if attached field_indices_subset (field_printer.hidden_fields) as hidden_fields then
				field_printer.set_displayable_fields (field_list.special_subset (hidden_fields))
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

feature -- Status query

	same_data_structure (a_field_hash: NATURAL): BOOLEAN
		-- `True' if order, type and names of fields are unchanged
		do
			Result := field_list.field_hash = a_field_hash
		end

	same_fields (a_current, other: EL_REFLECTIVE; name_list: STRING): BOOLEAN
		-- `True' if all fields in `name_list' have same value
		do
			Result := field_list.same_fields (a_current, other, field_indices_subset (name_list))
		end

feature {EL_FIELD_LIST} -- Factory

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
			create {EL_REFLECTED_BOOLEAN} Result.make (target, index, name)
		end

	new_reflected_field (field: EL_FIELD_TYPE_PROPERTIES; name: IMMUTABLE_STRING_8): EL_REFLECTED_FIELD
		do
			inspect field.abstract_type
				when Reference_type then
					Result := new_reference_field (target, field, name)

				when Expanded_type then
					Result := new_expanded_field (field.index, name)

			else
				if attached Standard_field_types [field.abstract_type] as field_type then
					Result := Field_factory.new_item (field_type, target, field.index, name)
				end
			end
		end

feature {EL_REFLECTION_HANDLER} -- Internal attributes

	tuple_field_table: EL_TUPLE_FIELD_TABLE

	field_info_table: EL_OBJECT_FIELDS_TABLE
		-- complete table of object field indices by name

end