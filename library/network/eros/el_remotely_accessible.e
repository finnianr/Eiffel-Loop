note
	description: "Summary description for {EL_REMOTELY_ACCESSIBLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:04:04 GMT (Monday 24th June 2013)"
	revision: "2"

deferred class
	EL_REMOTELY_ACCESSIBLE

inherit
	EL_MODULE_LOG

	EL_MODULE_STRING

	EL_REMOTE_CALL_CONSTANTS

	EL_REMOTE_CALL_ERRORS

feature {NONE} -- Initialization

	make
			--
		do
			create procedure_table.make (procedures)
			create function_table.make (functions)
			create string_result.make
		end

feature -- Access

	result_object: EVOLICITY_SERIALIZEABLE_AS_XML

feature -- Element change

	set_routine_with_arguments (
		routine_name: STRING; deserialized_object: EL_BUILDABLE_FROM_XML; argument_list: ARRAYED_LIST [STRING]
	)
			-- set either requested_procedure or requested_function
		local
			argument_tuple: TUPLE
			requested_routine: ROUTINE [like Current, TUPLE]
		do
			log.enter ("set_routine_with_arguments")
			set_error (0)
			set_error_detail ("")
			is_function_set := false
			is_procedure_set := false

			procedure_table.search (routine_name)
			if procedure_table.found then
				is_procedure_set := true
				requested_procedure := procedure_table.found_item
				requested_routine := requested_procedure
				argument_tuple := requested_procedure.empty_operands

			else
				function_table.search (routine_name)
				if function_table.found then
					is_function_set := true
					requested_function := function_table.found_item
					requested_routine := requested_function
					argument_tuple := requested_function.empty_operands

				end
			end
			if is_function_set or is_procedure_set then
				if argument_tuple.count = argument_list.count then
					set_routine_tuple (argument_tuple, deserialized_object, argument_list)
					requested_routine.set_operands (argument_tuple)
				else
					set_error (Error_wrong_number_of_arguments)
					set_error_detail ("should be " + argument_tuple.count.out)
				end
			else
				set_error (Error_routine_not_found)
				set_error_detail (routine_name + "?")

			end
			log.exit
		end

feature -- Basic operations

	call_procedure
			--
		require
			no_errors_setting_call_arguments: not has_error
		do
			log.enter ("call_routine")
			requested_procedure.apply
			result_object := Procedure_acknowledgement
			log.exit
		end

	call_function
			--
		require
			no_errors_setting_call_arguments: not has_error
		do
			log.enter ("call_function")
			requested_function.apply
			if attached {EVOLICITY_SERIALIZEABLE_AS_XML} requested_function.last_result as a_result_object then
				result_object := a_result_object

			elseif attached {STRING} requested_function.last_result as last_result  then
				string_result.set_value (last_result)
				result_object := string_result

			else
				string_result.set_value (requested_function.last_result.out)
				result_object := string_result

			end
			log.exit
		end

feature -- Status query

	is_function_set: BOOLEAN

	is_procedure_set: BOOLEAN

feature {NONE} -- Implementation

	set_routine_tuple (
		argument_tuple: TUPLE; deserialized_object: EL_BUILDABLE_FROM_XML; argument_list: ARRAYED_LIST [STRING]
	)
			--
		local
			argument: STRING
			i: INTEGER
		do
			from i := 1 until i > argument_list.count loop
				argument := argument_list [i]
				if String.has_enclosing (argument, once "''") then
					String.remove_single_quote (argument)
					set_tuple_string (argument_tuple, i, argument)

				elseif String.has_enclosing (argument, Curly_braces) then
					set_tuple_deserialized_object (argument_tuple, i, argument, deserialized_object)

				elseif String.has_enclosing (argument, Parenthesis) then
					String.remove_bookends (argument, Parenthesis)
					set_tuple_numeric (argument_tuple, i, argument)

				elseif String.has_enclosing (argument, Angle_brackets) then
					String.remove_bookends (argument, Angle_brackets)
					set_tuple_boolean (argument_tuple, i, argument)

				elseif String.has_enclosing (argument, Square_brackets) then
					String.remove_bookends (argument, Square_brackets)
					set_tuple_once_item (argument_tuple, i, argument)

				end
				i := i + 1
			end
		end

	set_tuple_string (argument_tuple: TUPLE; index: INTEGER; argument: STRING)
			--
		require
			valid_argument: argument_tuple.valid_type_for_index (argument, index)
		do
			if argument_tuple.valid_type_for_index (argument, index) then
				argument_tuple.put_reference (argument, index)
			else
				set_error (Error_argument_type_mismatch)
				set_error_detail (
					type_mismatch_error_message (argument_tuple.reference_item (index), argument_tuple.item (index))
				)
			end
		end

	set_tuple_deserialized_object (
		argument_tuple: TUPLE; index: INTEGER; argument: STRING; argument_object: EL_BUILDABLE_FROM_XML
	)
			--
		require
			valid_argument_object: argument_tuple.valid_type_for_index (argument_object, index)
		do
			if argument_tuple.valid_type_for_index (argument_object, index) then
				argument_tuple.put_reference (argument_object, index)
			else
				set_error (Error_argument_type_mismatch)
				set_error_detail (
					type_mismatch_error_message (argument_object, argument_tuple.item (index))
				)
			end
		end

	set_tuple_boolean (argument_tuple: TUPLE; index: INTEGER; argument: STRING)
			--
		require
			valid_argument: argument.is_boolean and then argument_tuple.is_boolean_item (index)
		do
			if argument.is_boolean and then argument_tuple.is_boolean_item (index) then
				argument_tuple.put_boolean (argument.to_boolean, index)

			else
				set_error (Error_argument_type_mismatch)
				set_error_detail ("expecting a boolean argument")

			end
		end

	set_tuple_numeric (argument_tuple: TUPLE; index: INTEGER; argument: STRING)
			--
		require
			valid_argument: argument.is_double and then
				argument_tuple.is_real_item (index) or else
				argument_tuple.is_double_item (index) or else
				argument_tuple.is_integer_8_item (index) or else
				argument_tuple.is_integer_16_item (index) or else
				argument_tuple.is_integer_32_item (index) or else
				argument_tuple.is_integer_64_item (index)

		local
			double: DOUBLE
			integer_64: INTEGER_64
		do
			if argument.is_double then
				if argument_tuple.is_double_item (index) and argument.is_double then
					argument_tuple.put_double (argument.to_double, index)

				elseif argument_tuple.is_real_item (index) and argument.is_real then
					argument_tuple.put_real (argument.to_real, index)

				elseif argument_tuple.is_integer_8_item (index) and argument.is_integer_8 then
					argument_tuple.put_integer_8 (argument.to_integer_8, index)

				elseif argument_tuple.is_integer_16_item (index) and argument.is_integer_16 then
					argument_tuple.put_integer_16 (argument.to_integer_16, index)

				elseif argument_tuple.is_integer_32_item (index) and argument.is_integer_32 then
					argument_tuple.put_integer_32 (argument.to_integer_32, index)

				elseif argument_tuple.is_integer_64_item (index) and argument.is_integer_64 then
					argument_tuple.put_integer_64 (argument.to_integer_64, index)

				else
					set_error (Error_argument_type_mismatch)
					if argument.is_integer_64 then
						set_error_detail (type_mismatch_error_message (integer_64, argument_tuple.item (index)))
					else
						set_error_detail (type_mismatch_error_message (double, argument_tuple.item (index)))
					end

				end
			else
				set_error (Error_argument_type_mismatch)
				set_error_detail ("Non numeric argument, expecting a " + argument_tuple.item (index).generator)

			end
		end

	set_tuple_once_item (argument_tuple: TUPLE; index: INTEGER; argument: STRING)
			--
		require
			once_function_exists: function_table.has (argument)
			once_function_takes_no_arguments: function_table.item (argument).open_count = 0
			valid_argument: argument_tuple.valid_type_for_index (function_table.item (argument).item ([]), index)
		local
			once_item: ANY
		do
			function_table.search (argument)
			if function_table.found then
				once_item := function_table.found_item.item ([])
				if argument_tuple.valid_type_for_index (once_item, index) then
					argument_tuple.put (once_item, index)
				else
					set_error (Error_argument_type_mismatch)
					set_error_detail (type_mismatch_error_message (once_item, argument_tuple.item (index)))
				end
			else
				set_error (Error_once_function_not_found)
				set_error_detail (argument)
			end
		end

	type_mismatch_error_message (actual, expected: ANY): STRING
			--
		do
			Type_mismatch_error_template.set_variables_from_array (<<
				[once "actual_type", actual.generator],
				[once "expected_type", expected.generator]
			>>)
			Result := Type_mismatch_error_template.substituted
		end

feature {NONE} -- Implementation: attributes

	string_result: EL_EROS_STRING_RESULT

	requested_procedure: PROCEDURE [like Current, TUPLE]

	requested_function: FUNCTION [like Current, TUPLE, ANY]

	procedure_table: EL_HASH_TABLE [like requested_procedure, STRING]

	function_table: EL_HASH_TABLE [like requested_function, STRING]

feature {NONE} -- User implementation

	procedures: ARRAY [like procedure_mapping]
			--
		deferred
		end

	functions: ARRAY [like function_mapping]
			--
		deferred
		end

feature {NONE} -- Anchored type declarations

	procedure_mapping: TUPLE [STRING, like requested_procedure]
			--
		require
			not_to_be_called: False
		do
		end

	function_mapping: TUPLE [STRING, like requested_function]
			--
		require
			not_to_be_called: False
		do
		end

feature {NONE} -- Constants

	Type_mismatch_error_template: EL_SUBSTITUTION_TEMPLATE [STRING]
			--
		once
			create Result.make ("is a $actual_type, should be: $expected_type")
		end

	Procedure_acknowledgement: EL_EROS_PROCEDURE_STATUS
			--
		once
			create Result.make
		end

	Curly_braces: STRING = "{}"

	Parenthesis: STRING = "()"

	Angle_brackets: STRING = "<>"

	Square_brackets: STRING = "[]"

	No_procedures: ARRAY [like procedure_mapping]
			--
		do
			create Result.make (1, 0)
		end

	No_functions: ARRAY [like function_mapping]
			--
		do
			create Result.make (1, 0)
		end

end
