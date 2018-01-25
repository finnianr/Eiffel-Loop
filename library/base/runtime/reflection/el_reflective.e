note
	description: "Stateless class with reflective routines"
	notes: "[
		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		It is permitted to have a trailing underscore to prevent clashes with Eiffel keywords.
		The field is settable with `set_field' by a name string that does not have a trailing underscore.

		To adapt foreign names that do not follow the Eiffel snake-case convention redefine `import_name'
		to return a routine in `EL_ATTRIBUTE_NAME_ROUTINES' prefixed with `from_'. To export Eiffel names
		redefine `export_name' to return a routine in `EL_ATTRIBUTE_NAME_ROUTINES' prefixed with `to_'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-23 12:51:23 GMT (Tuesday 23rd January 2018)"
	revision: "10"

deferred class
	EL_REFLECTIVE

inherit
	EL_MODULE_NAMING

	EL_REFLECTOR_CONSTANTS

feature -- Access

	field_name_list: EL_STRING_LIST [STRING]
		do
			Result := Meta_data_by_type.item (Current).field_array.name_list
		end

feature -- Comparison

	all_fields_equal (other: like Current): BOOLEAN
		do
			Result := Meta_data_by_type.item (Current).all_fields_equal (Current, other)
		end

feature -- Basic operations

	print_fields (lio: EL_LOGGABLE)
		do
			Meta_data_by_type.item (Current).print_fields (Current, lio)
		end

	print_meta_data (lio: EL_LOGGABLE)
		local
			i: INTEGER; array: ARRAY [EL_REFLECTED_FIELD]
		do
			array := Meta_data_by_type.item (Current).field_array
			lio.put_labeled_string ("class", generator)
			lio.tab_right
			lio.put_new_line
			from i := array.lower until i > array.upper loop
				array.item (i).print_meta_data (Current, lio, i, i = array.upper)
				i := i + 1
			end
			lio.tab_left
			lio.put_new_line
			lio.put_line ("end")
		end

feature -- Element change

	set_from_other (other: EL_REFLECTIVE; other_except_list: STRING)
		-- set fields in `Current' with identical fields from `other' except for
		-- other fields listed in comma-separated `other_except_list'
		local
			except_indices: EL_FIELD_INDICES_SET
			table, table_other: EL_REFLECTED_FIELD_TABLE
			field, other_field: EL_REFLECTED_FIELD
			meta_data: like Meta_data_by_type.item
		do
			meta_data := Meta_data_by_type.item (Current)
			table := meta_data.field_table
			except_indices := other.new_field_indices_set (other_except_list)
			table_other := Meta_data_by_type.item (other).field_table
			from table_other.start until table_other.after loop
				other_field := table_other.item_for_iteration
				if not except_indices.has (other_field.index) then
					table.search (other_field.name)
					if table.found then
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

	new_current_object (instance: ANY): REFLECTED_REFERENCE_OBJECT
		local
			pool: like Object_pool
		do
			pool := Object_pool
			if pool.is_empty then
				create Result.make (instance)
			else
				Result := pool.item
				Result.set_object (instance)
				pool.remove
			end
		end

	new_field_indices_set (field_names: STRING): EL_FIELD_INDICES_SET
		do
			create Result.make (current_object, field_names)
		end

	new_meta_data: EL_CLASS_META_DATA --like Meta_data_by_type.item
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
			meta_data: like Meta_data_by_type.item; table: EL_REFLECTED_FIELD_TABLE
			export_names: ARRAY [STRING]; query_results: LIST [EL_REFLECTED_FIELD]
		do
			meta_data := Meta_data_by_type.item (Current)
			export_names := meta_data.exported_names
			table := meta_data.field_table
			table.query_by_type (value_table.value_type)
			query_results := table.last_query
			from query_results.start until query_results.after loop
				value_table.set_value (export_names [query_results.item.index], query_results.item.value (Current))
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

feature {EL_CLASS_META_DATA, EL_REFLECTED_FIELD_ARRAY} -- Implementation

	export_name: like Naming.default_export
		-- returns a procedure to export names to a foreign naming convention.
		--  `Standard_eiffel' means that external names already follow the Eiffel convention
		do
			Result := Naming.default_export
		end

	field_included (object: like current_object; index: INTEGER): BOOLEAN
		deferred
		end

	import_name: like Naming.default_export
		-- returns a procedure to import names using a foreing naming convention to the Eiffel convention.
		--  `Standard_eiffel' means the external name already follows the Eiffel convention
		do
			Result := Naming.default_export
		end

feature {NONE} -- Implementation

	current_reflective: like Current
		do
			Result := Current
		end

	recycle (object: like new_current_object)
		do
			object.set_object (0)
			Object_pool.put (object)
		end

	set_reference_fields (type: TYPE [ANY]; new_object: FUNCTION [STRING, ANY])
		-- set reference fields of `type' with `new_object' taking a exported name
		require
			reference_type: not type.is_expanded
			type_same_as_function_result_type: new_object.generating_type.generic_parameter_type (2) ~ type
		local
			table: EL_REFLECTED_FIELD_TABLE; export_names: ARRAY [STRING]
			meta_data: like Meta_data_by_type.item
		do
			meta_data := Meta_data_by_type.item (Current)
			export_names := meta_data.exported_names
			table := meta_data.field_table
			from table.start until table.after loop
				if attached {EL_REFLECTED_REFERENCE} table.item_for_iteration as ref_field
					and then ref_field.type_id = type.type_id
				then
					ref_field.set (Current, new_object (export_names [ref_field.index]))
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

	frozen Object_pool: ARRAYED_STACK [REFLECTED_REFERENCE_OBJECT]
		once
			create Result.make (3)
		end

	frozen Once_current_object: REFLECTED_REFERENCE_OBJECT
		once
			create Result.make (Current)
		end

end
