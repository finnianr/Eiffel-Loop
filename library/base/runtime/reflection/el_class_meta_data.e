note
	description: "Class reflective meta data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-01 13:33:21 GMT (Tuesday   1st   October   2019)"
	revision: "16"

class
	EL_CLASS_META_DATA

inherit
	REFLECTED_REFERENCE_OBJECT
		export
			{NONE} all
		redefine
			make, enclosing_object
		end

	EL_REFLECTOR_CONSTANTS

	EL_MODULE_EIFFEL

	EL_MODULE_NAMING

	EL_SHARED_NEW_INSTANCE_TABLE

	EL_REFLECTION_HANDLER

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_enclosing_object: like enclosing_object)
		do
			Precursor (a_enclosing_object)
			New_instance_table.extend_from_array (a_enclosing_object.new_instance_functions)
			create cached_field_indices_set.make_equal (3, agent new_field_indices_set)
			excluded_fields := cached_field_indices_set.item (a_enclosing_object.Except_fields)
			hidden_fields := cached_field_indices_set.item (a_enclosing_object.Hidden_fields)
			create field_array.make (new_field_list.to_array)
			field_table := field_array.to_table (a_enclosing_object)
		end

feature -- Access

	excluded_fields: EL_FIELD_INDICES_SET

	field_array: EL_REFLECTED_FIELD_ARRAY

	field_table: EL_REFLECTED_FIELD_TABLE

	hidden_fields: EL_FIELD_INDICES_SET

	sink_except (a_object: EL_REFLECTIVE; sinkable: EL_DATA_SINKABLE; field_names: STRING)
		do
			field_array.sink_except (a_object, sinkable, new_field_indices_set (field_names))
		end

feature -- Basic operations

	print_fields (a_object: EL_REFLECTIVE; a_lio: EL_LOGGABLE)
		local
			line_length, length: INTEGER
			name: STRING; value: ZSTRING; l_field: EL_REFLECTED_FIELD
		do
			value := String_8_pool.new_string
			across field_array as fld loop
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

feature -- Comparison

	all_fields_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		local
			i, count: INTEGER; array: like field_array
		do
			array := field_array; count := array.count
			Result := True
			from i := 1 until not Result or i > count loop
				Result := array.item (i).are_equal (a_current, other)
				i := i + 1
			end
		end

feature {NONE} -- Factory

	new_field_indices_set (field_names: STRING): EL_FIELD_INDICES_SET
		do
			if field_names.is_empty then
				Result := Empty_field_indices_set
			else
				create Result.make (Current, field_names)
			end
		end

	new_field_list: ARRAYED_LIST [EL_REFLECTED_FIELD]
		local
			i: INTEGER; name: STRING; excluded: like excluded_fields
		do
			excluded := excluded_fields
			create Result.make (field_count - excluded.count)
			from i := 1 until i > field_count loop
				if not excluded.has (i) and then enclosing_object.field_included (field_type (i), field_static_type (i)) then
					name := field_name (i)
					-- if not a once ("OBJECT") field
					if name [1] /= '_' then
						name.prune_all_trailing ('_')
						Result.extend (new_reflected_field (i, name))
					end
				end
				i := i + 1
			end
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
			if type = Reference_type then
				Result := new_reference_field (index, name)
			else
				Result := new_reflected_field_for_type (Expanded_field_types [type], index, name)
			end
		end

	new_reflected_field_for_type (type: TYPE [EL_REFLECTED_FIELD]; index: INTEGER; name: STRING): EL_REFLECTED_FIELD
		do
			if attached {EL_REFLECTED_FIELD} Eiffel.new_instance_of (type.type_id) as new_field then
				Result := new_field
				Result.make (enclosing_object, index, name)
			end
		end

feature {NONE} -- Internal attributes

	cached_field_indices_set: EL_CACHE_TABLE [EL_FIELD_INDICES_SET, STRING]

	enclosing_object: EL_REFLECTIVE

feature {NONE} -- Constants

	Empty_field_indices_set: EL_FIELD_INDICES_SET
		once
			create Result.make_empty
		end

	Info_line_length: INTEGER
		once
			Result := 100
		end

	frozen Expanded_field_types: ARRAY [TYPE [EL_REFLECTED_FIELD]]
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

	Reference_type_tables: ARRAY [EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY], ANY]]
		once
			Result := <<
				String_type_table,
				Boolean_ref_type_table,
				Makeable_from_string_type_table,
				String_convertable_type_table,
				String_collection_type_table,
				Numeric_collection_type_table,
				Other_collection_type_table
			>>
		end
end
