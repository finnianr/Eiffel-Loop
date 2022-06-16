note
	description: "Class reflective meta data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-14 15:54:08 GMT (Tuesday 14th June 2022)"
	revision: "49"

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
			item as sink_except_fields,
			new_item as new_sink_except_fields
		end

	EL_LAZY_ATTRIBUTE_2
		rename
			item as alphabetical_list,
			new_item as new_alphabetical_list
		end

	EL_REFLECTION_CONSTANTS

	EL_MODULE_EIFFEL

	EL_MODULE_NAMING

	EL_REFLECTION_HANDLER

	EL_STRING_8_CONSTANTS

	EL_SHARED_NEW_INSTANCE_TABLE

	EL_SHARED_READER_WRITER_TABLE

	EL_SHARED_CLASS_ID

create
	make

feature {NONE} -- Initialization

	make (a_enclosing_object: like enclosing_object)
		do
			Precursor (a_enclosing_object)
			New_instance_table.extend_from_list (a_enclosing_object.new_instance_functions)
			across a_enclosing_object.new_reader_writer_interfaces as interface loop
				Reader_writer_table.put (interface.item, interface.key.type_id)
			end
			create cached_field_indices_set.make_equal (3, agent new_field_indices_set)
			excluded_fields := cached_field_indices_set.item (a_enclosing_object.Transient_fields)

			hidden_fields := cached_field_indices_set.item (a_enclosing_object.Hidden_fields)
			representations := enclosing_object.new_representations
			field_list := new_field_list
			field_table := field_list.to_table (a_enclosing_object)
			if attached a_enclosing_object.foreign_naming as foreign_naming then
				across field_table as table loop
					foreign_naming.inform (table.key)
				end
			end
		ensure then
			same_order: across field_table as table all
				table.key.is_equal (field_list.i_th (table.cursor_index).name)
			end
		end

feature -- Access

	enclosing_object: EL_REFLECTIVE

	excluded_fields: EL_FIELD_INDICES_SET

	field_list: EL_REFLECTED_FIELD_LIST

	field_table: EL_REFLECTED_FIELD_TABLE

	hidden_fields: EL_FIELD_INDICES_SET

	sink_except (a_object: EL_REFLECTIVE; sinkable: EL_DATA_SINKABLE; a_excluded_fields: STRING)
		do
			if attached sink_except_fields as cached then
				field_list.sink_except (a_object, sinkable, cached.item (a_excluded_fields))
			end
		end

feature -- Basic operations

	print_fields (a_object: EL_REFLECTIVE; a_lio: EL_LOGGABLE)
		local
			line_length, length: INTEGER
			name: STRING; value: ZSTRING; l_field: EL_REFLECTED_FIELD
		do
			create value.make_empty
			across field_list as fld loop
				l_field := fld.item
				if not hidden_fields.has (l_field.index) then
					name := l_field.name
					value.wipe_out
					value.append_string_general (l_field.to_string (a_object))
					length := name.count + value.count + 2
					if line_length > 0 then
						a_lio.put_string (", ")
						if line_length + length > Info_line_length then
							a_lio.put_new_line
							line_length := 0
						end
					end
					a_lio.put_labeled_string (name, value)
					line_length := line_length + length
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

feature -- Comparison

	all_fields_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		local
			i, count: INTEGER; array: like field_list
		do
			array := field_list; count := array.count
			Result := True
			from i := 1 until not Result or i > count loop
				Result := array.i_th (i).are_equal (a_current, other)
				i := i + 1
			end
		end

feature {NONE} -- Factory

	new_alphabetical_list: EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		-- fields sorted alphabetically
		do
			Result := field_list.ordered_by (agent {EL_REFLECTED_FIELD}.name, True)
		end

	new_expanded_field (index: INTEGER; name: STRING): EL_REFLECTED_FIELD
		local
			type_id: INTEGER
		do
			type_id := field_static_type (index)
			if type_id = Class_id.EL_CODE_STRING then
				create {EL_REFLECTED_CODE_STRING} Result.make (enclosing_object, index, name)

			else
				create {EL_REFLECTED_REFERENCE [ANY]} Result.make (enclosing_object, index, name)
			end
		end

	new_field_factory (type: TYPE [EL_REFLECTED_FIELD]): EL_REFLECTED_FIELD_FACTORY [EL_REFLECTED_FIELD]
		do
			if attached {like new_field_factory} Eiffel.new_factory_instance ({like new_field_factory}, type) as new then
				Result := new
			end
		end

	new_field_indices_set (field_names: STRING): EL_FIELD_INDICES_SET
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
			i, count: INTEGER; excluded: like excluded_fields
		do
			excluded := excluded_fields; count := field_count
			create Result.make (count - excluded.count)
			from i := 1 until i > count loop
				if not (is_field_transient (i) or else excluded.has (i))
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
			type_id: INTEGER; found: BOOLEAN
		do
			type_id := field_static_type (index)
			across Reference_type_tables as table until found loop
				if table.item.has_type (type_id) then
					Result := new_reflected_field_for_type (table.item.found_item, index, name)
					found := True
				end
			end
			if not found then
				create {EL_REFLECTED_REFERENCE [ANY]} Result.make (enclosing_object, index, name)
			end
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
				Result := new_reflected_field_for_type (Standard_field_types [type], index, name)
			end
		end

	new_reflected_field_for_type (type: TYPE [EL_REFLECTED_FIELD]; index: INTEGER; name: STRING): EL_REFLECTED_FIELD
		do
			if attached new_field_factory (type) as factory then
				Result := factory.new_item (enclosing_object, index, name)
				if representations.has_key (name) then
					Result.set_representation (representations.found_item)
					if attached {EL_HASH_SET_REPRESENTATION [HASHABLE]} Result.representation then
						if attached {EL_REFLECTED_ZSTRING} Result as l_field then
							create {EL_REFLECTED_MEMBER_ZSTRING} Result.make (l_field)

						elseif attached {EL_REFLECTED_STRING_8} Result as l_field then
							create {EL_REFLECTED_MEMBER_STRING_8} Result.make (l_field)

						elseif attached {EL_REFLECTED_STRING_32} Result as l_field then
							create {EL_REFLECTED_MEMBER_STRING_32} Result.make (l_field)
						end
					end
				end
			else
				create {EL_REFLECTED_REFERENCE [ANY]} Result.make (enclosing_object, index, name)
			end
		ensure
			same_type: not representations.has (name) implies Result.generating_type ~ type
		end

	new_sink_except_fields: EL_CACHE_TABLE [EL_FIELD_INDICES_SET, STRING]
		-- fields excluded by `sink_except' by `a_excluded_fields'
		do
			create Result.make_equal (11, agent new_field_indices_set)
		end

feature {NONE} -- Implementation

	is_once_object (name: STRING): BOOLEAN
		-- `True' if `name' is a once ("OBJECT") field name
		do
			Result := name.count > 0 and then name [1] = '_'
		end

feature {NONE} -- Internal attributes

	cached_field_indices_set: EL_CACHE_TABLE [EL_FIELD_INDICES_SET, STRING]

	representations: like enclosing_object.new_representations

feature {NONE} -- Constants

	Empty_field_indices_set: EL_FIELD_INDICES_SET
		once
			create Result.make_empty
		end

	Info_line_length: INTEGER
		once
			Result := 100
		end

	Reference_type_tables: ARRAY [EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY]]]
		once
			Result := <<
				String_type_table,
				Boolean_ref_type_table,
				Makeable_from_string_type_table,
				String_convertable_type_table,
				Collection_type_table
			>>
		end

	frozen Standard_field_types: ARRAY [TYPE [EL_REFLECTED_FIELD]]
		-- standard expanded types
		once
			create Result.make_filled ({EL_REFLECTED_CHARACTER_8}, 0, 16)
				-- Characters
				Result [Character_8_type] := {EL_REFLECTED_CHARACTER_8}
				Result [Character_32_type] := {EL_REFLECTED_CHARACTER_32}

				-- Integers
				Result [Integer_8_type] := {EL_REFLECTED_INTEGER_8}
				Result [Integer_16_type] := {EL_REFLECTED_INTEGER_16}
				Result [Integer_32_type] := {EL_REFLECTED_INTEGER_32}
				Result [Integer_64_type] := {EL_REFLECTED_INTEGER_64}

				-- Naturals
				Result [Natural_8_type] := {EL_REFLECTED_NATURAL_8}
				Result [Natural_16_type] := {EL_REFLECTED_NATURAL_16}
				Result [Natural_32_type] := {EL_REFLECTED_NATURAL_32}
				Result [Natural_64_type] := {EL_REFLECTED_NATURAL_64}

				-- Reals
				Result [Real_32_type] := {EL_REFLECTED_REAL_32}
				Result [Real_64_type] := {EL_REFLECTED_REAL_64}

				-- Others
				Result [Boolean_type] := {EL_REFLECTED_BOOLEAN}
				Result [Pointer_type] := {EL_REFLECTED_POINTER}
			end

end