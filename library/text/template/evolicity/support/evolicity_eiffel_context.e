note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 18:40:12 GMT (Friday 24th June 2016)"
	revision: "6"

deferred class
	EVOLICITY_EIFFEL_CONTEXT

inherit
	EVOLICITY_CONTEXT
		rename
			objects as getter_functions
		redefine
			context_item, put_variable, put_integer
		end

	EL_REFLECTION

	EL_STRING_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			getter_functions := Getter_functions_by_type.item ({like Current}, agent new_getter_functions)
		end

feature -- Element change

	put_boolean (variable_name: ZSTRING; value: BOOLEAN)
			--
		do
			getter_functions [variable_name] := agent get_context_item (value.to_reference)
		end

	put_double (variable_name: ZSTRING; value: DOUBLE)
			--
		do
			getter_functions [variable_name] := agent get_context_item (value.to_reference)
		end

	put_integer (variable_name: ZSTRING; value: INTEGER)
			--
		do
			getter_functions [variable_name] := agent get_context_item (value.to_real.to_reference)
		end

	put_quoted_string (variable_name: ZSTRING; a_string: READABLE_STRING_GENERAL; count: INTEGER)
		local
			l_string: ZSTRING
		do
			create l_string.make_from_unicode (a_string)
			put_string (variable_name, l_string.quoted (count))
		end

	put_real (variable_name: ZSTRING; value: REAL)
			--
		do
			getter_functions [variable_name] := agent get_context_item (value.to_reference)
		end

	put_string (variable_name: ZSTRING; value: READABLE_STRING_GENERAL)
			--
		do
			put_variable (value, variable_name)
		end

	put_variable (object: ANY; variable_name: ZSTRING)
			-- the order (value, variable_name) is special case due to function_item assign
		do
			getter_functions [variable_name] := agent get_context_item (object)
		end

	put_variables (variable_name_and_value_array: ARRAY [TUPLE])
			--
		require
			valid_tuples:
				across variable_name_and_value_array as tuple all
					tuple.item.count = 2 and then attached {READABLE_STRING_GENERAL} tuple.item.reference_item (1)
				end
		local
			value_ref: ANY; variable_name: ZSTRING
		do
			across variable_name_and_value_array as tuple loop
				if attached {READABLE_STRING_GENERAL} tuple.item.reference_item (1) as general_string then
					if attached {ZSTRING} general_string as el_astring then
						variable_name := el_astring
					else
						create variable_name.make_from_unicode (general_string)
					end
					if tuple.item.is_double_item (2) then
						put_double (variable_name, tuple.item.real_64_item (2))

					elseif tuple.item.is_real_item (2) then
						put_real (variable_name, tuple.item.real_32_item (2))

					elseif tuple.item.is_integer_item (2) then
						put_integer (variable_name, tuple.item.integer_32_item (2))

					else
						value_ref := tuple.item.reference_item (2)
						if attached {READABLE_STRING_GENERAL} value_ref as str_value then
							put_string (variable_name, str_value)
						else
							put_string (variable_name, value_ref.out)
						end
					end
				end
			end
		end

feature -- Access

	context_item (key: ZSTRING; function_args: ARRAY [ANY]): ANY
			--
		require else
			valid_function_args:
				attached {FUNCTION [like Current, TUPLE, ANY]} function_item (key) as function
					implies function.open_count = function_args.count
		local
			i: INTEGER; operands: TUPLE; template: ZSTRING
		do
			Result := function_item (key)
			if attached {FUNCTION [like Current, TUPLE, ANY]} Result as getter_action then
				getter_action.set_target (Current)
				if getter_action.open_count = 0 then
					getter_action.apply
					Result := getter_action.last_result

				elseif getter_action.open_count = function_args.count then
					operands := getter_action.empty_operands
					from i := 1 until i > function_args.count loop
						operands.put (function_args [i], i)
						i := i + 1
					end
					Result := getter_action.item (operands)
				else
					template := "Invalid open argument count: %S {%S}.%S"
					Result := template #$ [getter_action.open_count, generator, key]
				end
			end
		end

	function_item (key: ZSTRING): ANY assign put_variable
		do
			Result := getter_functions.item (key)
		end

feature {NONE} -- Implementation

	get_context_item (a_item: ANY): ANY
			--
		do
			Result := a_item
		end

	field_table (field_type: INTEGER; except_fields: ARRAY [STRING]): HASH_TABLE [ANY, STRING]
		do
			Result := field_table_with_condition (field_type, except_fields, False)
		end

	field_table_with_condition (field_type: INTEGER; except_fields: ARRAY [STRING]; non_zero: BOOLEAN): like field_table
		local
			object: REFLECTED_REFERENCE_OBJECT
			i, field_count, value: INTEGER
			adapted_field_names: like new_adapted_field_names; excluded_indices: like new_field_set
		do
			object := Once_current_object; current_object.set_object (Current)
			field_count := current_object.field_count
			adapted_field_names := Adapted_field_names_by_type.item ({like Current}, agent new_adapted_field_names)
			excluded_indices := Excluded_fields_by_type.item ({like Current}, agent new_field_set (except_fields))
			create Result.make_equal (field_count - except_fields.count)
			from i := 1 until i > field_count loop
				if not excluded_indices.has (i) then
					if object.field_type (i) = Integer_type then
						value := object.integer_32_field (i)
						if non_zero implies value > 0 then
							Result.extend (value.to_reference, adapted_field_names [i])
						end
					end
				end
				i := i + 1
			end
		end

	string_field_table (
		except_fields: ARRAY [STRING]; escaper: EL_CHARACTER_ESCAPER [ZSTRING]
	): HASH_TABLE [ZSTRING, STRING]
		do
			Result := string_field_table_with_condition (except_fields, escaper, False)
		end

	string_field_table_with_condition (
		except_fields: ARRAY [STRING]; escaper: EL_CHARACTER_ESCAPER [ZSTRING];  non_empty: BOOLEAN
	): like string_field_table
		local
			object: REFLECTED_REFERENCE_OBJECT
			i, field_count: INTEGER; value: ZSTRING
			adapted_field_names: like new_adapted_field_names; excluded_indices: like new_field_set
			is_escaped: BOOLEAN
		do
			object := Once_current_object; current_object.set_object (Current)
			field_count := current_object.field_count
			adapted_field_names := Adapted_field_names_by_type.item ({like Current}, agent new_adapted_field_names)
			excluded_indices := Excluded_fields_by_type.item ({like Current}, agent new_field_set (except_fields))
			is_escaped := escaper.generating_type /~ {EL_DO_NOTHING_CHARACTER_ESCAPER [ZSTRING]}
			create Result.make_equal (field_count - except_fields.count)
			from i := 1 until i > field_count loop
				if not excluded_indices.has (i) then
					if object.field_static_type (i) = String_z_type then
						if attached {ZSTRING} object.reference_field (i) as z_str then
							if is_escaped then
								value := z_str.escaped (escaper)
							else
								value := z_str
							end
							if non_empty implies not value.is_empty then
								Result.extend (value, adapted_field_names [i])
							end
						end
					end
				end
				i := i + 1
			end
		end

feature {EVOLICITY_COMPOUND_DIRECTIVE} -- Implementation

	new_getter_functions: like getter_functions
			--
		do
			Result := getter_function_table
			Result.compare_objects
		end

	new_adapted_field_names: ARRAY [STRING]
		local
			object: REFLECTED_REFERENCE_OBJECT; i, field_count: INTEGER
		do
			object := Once_current_object; current_object.set_object (Current)
			field_count := object.field_count
			create Result.make_filled (Empty_string_8, 1, field_count)
			from i := 1 until i > field_count loop
				Result [i] := adapted_field_name (object, i)
				i := i + 1
			end
		end

	getter_function_table: like getter_functions
			--
		deferred
		end

	getter_functions: EVOLICITY_OBJECT_TABLE [FUNCTION [EVOLICITY_EIFFEL_CONTEXT, TUPLE, ANY]]

feature {NONE} -- Constants

	Excluded_fields_by_type: EL_TYPE_TABLE [EL_HASH_SET [INTEGER]]
		once
			create Result.make_equal (17)
		end

	Getter_functions_by_type: EL_TYPE_TABLE [EVOLICITY_OBJECT_TABLE [FUNCTION [EVOLICITY_EIFFEL_CONTEXT, TUPLE, ANY]]]
		once
			create Result.make_equal (19)
		end

	Adapted_field_names_by_type: EL_TYPE_TABLE [ARRAY [STRING]]
		once
			create Result.make_equal (19)
		end

	Hyphenated_names: HASH_TABLE [STRING, STRING]
		once
			create Result.make_equal (17)
		end

end