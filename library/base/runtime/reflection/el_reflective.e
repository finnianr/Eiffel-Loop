note
	description: "Stateless class with reflective routines"
	notes: "[
		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		It is permitted to have a trailing underscore to prevent clashes with Eiffel keywords.
		The field is settable with `set_field' by a name string that does not have a trailing underscore.

		To adapt foreign names that do not follow the Eiffel snake_case word separation convention,
		rename `import_name' in the inheritance clause to one of the predefined routines `from_*'.
		If no adaptation is need rename it to `import_default'. Rename `export_name' in a similar manner
		as required. Name exporting routines are named `to_*'.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 10:58:38 GMT (Tuesday 24th April 2018)"
	revision: "14"

deferred class
	EL_REFLECTIVE

inherit
	EL_WORD_SEPARATION_ADAPTER
		export
			{NONE} all
			{EL_REFLECTION_HANDLER} export_name, import_name
		end

	EL_REFLECTOR_CONSTANTS

feature {NONE} -- Initialization

	initialize_fields
		-- set fields that have not already been initialized with a value
		do
			meta_data.field_array.do_if (
				agent {EL_REFLECTED_FIELD}.initialize (Current),
				agent {EL_REFLECTED_FIELD}.is_uninitialized (Current)
			)
		end

feature -- Access

	field_name_list: EL_STRING_LIST [STRING]
		do
			Result := meta_data.field_array.name_list
		end

feature {EL_REFLECTION_HANDLER} -- Access

	field_table: EL_REFLECTED_FIELD_TABLE
		do
			Result := meta_data.field_table
		end

	meta_data: like Meta_data_by_type.item
		do
			Result := Meta_data_by_type.item (Current)
		end

feature -- Comparison

	all_fields_equal (other: like Current): BOOLEAN
		do
			Result := meta_data.all_fields_equal (Current, other)
		end

feature -- Basic operations

	print_fields (lio: EL_LOGGABLE)
		do
			meta_data.print_fields (Current, lio)
		end

	print_meta_data (lio: EL_LOGGABLE)
		do
			lio.put_labeled_string ("class", generator)
			lio.tab_right
			lio.put_new_line
			print_field_meta_data (lio, meta_data.field_array)
			lio.tab_left
			lio.put_new_line
			lio.put_line ("end")
		end

feature -- Element change

	reset_fields
		-- reset fields in `field_table'
		-- expanded fields are reset to default values
		-- fields conforming to `BAG [ANY]' are wiped out (including strings)
		-- fields conforming to `EL_MAKEABLE_FROM_STRING' are reinitialized
		do
			meta_data.field_array.do_all (agent {EL_REFLECTED_FIELD}.reset (Current))
		end

	set_from_other (other: EL_REFLECTIVE; other_except_list: STRING)
		-- set fields in `Current' with identical fields from `other' except for
		-- other fields listed in comma-separated `other_except_list'
		local
			except_indices: EL_FIELD_INDICES_SET
			table, table_other: EL_REFLECTED_FIELD_TABLE
			field, other_field: EL_REFLECTED_FIELD
			l_meta_data: like Meta_data_by_type.item
		do
			l_meta_data := meta_data
			table := l_meta_data.field_table
			except_indices := other.new_field_indices_set (other_except_list)
			table_other := Meta_data_by_type.item (other).field_table
			from table_other.start until table_other.after loop
				other_field := table_other.item_for_iteration
				if not except_indices.has (other_field.index) then
					if table.has_name (other_field.name, Current) then
						field := table.found_item
						if other_field.type_id = field.type_id then
							field.set (Current, other_field.value (other))
						end
					end
				end
				table_other.forth
			end
		end

feature {EL_REFLECTIVE} -- Factory

	new_field_indices_set (field_names: STRING): EL_FIELD_INDICES_SET
		do
			create Result.make (current_object, field_names)
		end

	new_meta_data: EL_CLASS_META_DATA
		do
			create Result.make (Current)
		end

feature {NONE} -- Implementation

	current_object: like Once_current_object
		do
			Result := Once_current_object; Result.set_object (Current)
		end

	fill_field_value_table (value_table: EL_FIELD_VALUE_TABLE [ANY])
		-- fill
		local
			l_meta_data: like Meta_data_by_type.item; table: EL_REFLECTED_FIELD_TABLE
			query_results: LIST [EL_REFLECTED_FIELD]
		do
			l_meta_data := meta_data
			table := l_meta_data.field_table
			table.query_by_type (value_table.value_type)
			query_results := table.last_query
			from query_results.start until query_results.after loop
				value_table.set_value (query_results.item.export_name, query_results.item.value (Current))
				query_results.forth
			end
		end

	is_any_field (object: REFLECTED_REFERENCE_OBJECT; index: INTEGER_32): BOOLEAN
		do
			Result := True
		end

	is_string_or_expanded_field (object: REFLECTED_REFERENCE_OBJECT; index: INTEGER_32): BOOLEAN
		do
			inspect object.field_type (index)
				when Reference_type then
					Result := String_types.has (object.field_static_type (index))
				when Pointer_type then
			else
				Result := True
			end
		end

feature {EL_CLASS_META_DATA} -- Implementation

	current_reflective: like Current
		do
			Result := Current
		end

	default_values: ARRAY [ANY]
		do
			create Result.make_empty
		end

	field_included (object: like current_object; index: INTEGER): BOOLEAN
		deferred
		end

	print_field_meta_data (lio: EL_LOGGABLE; array: ARRAY [EL_REFLECTED_FIELD])
		local
			i: INTEGER
		do
			from i := 1 until i > array.upper loop
				array.item (i).print_meta_data (Current, lio, i, i = array.upper)
				i := i + 1
			end
		end

	set_reference_fields (type: TYPE [ANY]; new_object: FUNCTION [STRING, ANY])
		-- set reference fields of `type' with `new_object' taking a exported name
		require
			reference_type: not type.is_expanded
			type_same_as_function_result_type: new_object.generating_type.generic_parameter_type (2) ~ type
		local
			table: EL_REFLECTED_FIELD_TABLE; l_meta_data: like meta_data
		do
			l_meta_data := meta_data
			table := l_meta_data.field_table
			from table.start until table.after loop
				if attached {EL_REFLECTED_REFERENCE} table.item_for_iteration as ref_field
					and then ref_field.type_id = type.type_id
				then
					ref_field.set (Current, new_object (ref_field.export_name))
				end
				table.forth
			end
		end

feature {EL_CLASS_META_DATA} -- Constants

	Except_fields: STRING
			-- list of comma-separated fields to be excluded
		once
			create Result.make_empty
		ensure
			no_leading_comma: not Result.is_empty implies not (Result [1] = ',')
		end

	Hidden_fields: STRING
			-- Fields that will not be output by `print_fields'
			-- Must be comma-separated names
		once
			create Result.make_empty
		ensure
			no_leading_comma: not Result.is_empty implies not (Result [1] = ',')
		end

	Meta_data_by_type: EL_FUNCTION_RESULT_TABLE [EL_REFLECTIVE, EL_CLASS_META_DATA]
		once
			create Result.make (11, agent {EL_REFLECTIVE}.new_meta_data)
		end

	frozen Once_current_object: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (Current)
		end

note
	descendants: "[
			EL_REFLECTIVE*
				[$source EL_BOOLEAN_REF]
					[$source PP_ADDRESS_STATUS]
				[$source EL_REFLECTIVE_RSA_KEY]*
					[$source EL_RSA_PRIVATE_KEY]
					[$source EL_RSA_PUBLIC_KEY]
				[$source EL_REFLECTIVELY_SETTABLE]*
	]"

end
