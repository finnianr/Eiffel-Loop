note
	description: "Object that is remotely accessible via EROS protocol"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "15"

deferred class
	EROS_REMOTELY_ACCESSIBLE

inherit
	EROS_OBJECT
		rename
			make_default as make
		redefine
			make
		end

	EL_MODULE_LOG

	EROS_REMOTE_CALL_CONSTANTS

	EROS_REMOTE_CALL_ERRORS
		rename
			make_default as make
		redefine
			make
		end

feature {EROS_CALL_REQUEST_HANDLER_I} -- Initialization

	make
			--
		do
			Precursor {EROS_OBJECT}
			Precursor {EROS_REMOTE_CALL_ERRORS}
			create string_result.make
			create argument_list.make_empty
			routine := Default_routine
			result_object := Procedure_acknowledgement
		end

feature -- Access

	result_object: EVOLICITY_SERIALIZEABLE_AS_XML

feature -- Element change

	set_arguments (request_parser: EROS_CALL_REQUEST_PARSER)
			-- set `routine' arguments
		local
			routine_name: STRING
		do
			log.enter (once "set_routine_with_arguments")
			reset_errors
			routine_name := request_parser.routine_name
			argument_list := request_parser.argument_list
			if routine_table.has_key (routine_name) then
				routine := routine_table.found_item
				if routine.arguments.count = argument_list.count then
					if request_parser.has_call_argument then
						set_request_arguments (request_parser.call_argument)
					else
						set_request_arguments (Void)
					end
				else
					set_error (Error.wrong_number_of_arguments, "should be " + routine.arguments.count.out)
				end
			else
				set_error (Error.routine_not_found, routine_name + "?")
				routine := Default_routine
			end
			log.exit
		end

feature -- Basic operations

	call_routine
			--
		require
			no_errors_setting_call_arguments: not has_error
		do
			log.enter (once "call_routine")
			routine.apply
			if routine.is_procedure then
				result_object := Procedure_acknowledgement

			elseif attached {FUNCTION [ANY]} routine.item as function then
				if attached {EVOLICITY_SERIALIZEABLE_AS_XML} function.last_result as l_result then
					result_object := l_result

				elseif attached {STRING} function.last_result as last_result  then
					string_result.set_value (last_result)
					result_object := string_result

				else
					string_result.set_value (function.last_result.out)
					result_object := string_result
				end
			end
			log.exit
		end

feature -- Status query

	is_routine_set: BOOLEAN
		do
			Result := routine /= Default_routine
		end

	function_requested: BOOLEAN
		do
			Result := routine.is_function
		end

feature {NONE} -- Implementation

	set_request_arguments (call_argument: detachable EL_BUILDABLE_FROM_NODE_SCAN)
		local
			argument: STRING; i: INTEGER; s: EL_STRING_8_ROUTINES
		do
			from i := 1 until i > argument_list.count or has_error loop
				argument := argument_list [i]
				if s.has_enclosing (argument, once "''") then
					s.remove_single_quote (argument)
					set_string_argument (i, argument)

				elseif s.has_enclosing (argument, Curly_braces)
					and then attached call_argument as deserialized_object
				then
					set_deserialized_object_argument (i, argument, deserialized_object)

				elseif routine_table.has (argument) then
					set_once_routine_argument (i, argument)

				elseif s.is_convertible (argument, routine.argument_types [i]) then
					-- Convertible to one of 13 basic types
					routine.arguments.put (s.to_type (argument, routine.argument_types [i]), i)

				else
					set_type_mismatch_error (i, argument)
				end
				i := i + 1
			end
		end

	set_string_argument (index: INTEGER; argument: STRING)
			--
		require
			valid_argument: routine.arguments.valid_type_for_index (argument, index)
		do
			if routine.arguments.valid_type_for_index (argument, index) then
				routine.arguments.put_reference (argument, index)
			else
				set_type_mismatch_error (index, argument)
			end
		end

	set_deserialized_object_argument (index: INTEGER; argument: STRING; argument_object: EL_BUILDABLE_FROM_NODE_SCAN)
		require
			valid_argument_object: routine.arguments.valid_type_for_index (argument_object, index)
		do
			if routine.arguments.valid_type_for_index (argument_object, index) then
				routine.arguments.put_reference (argument_object, index)
			else
				set_type_mismatch_error (index, argument)
			end
		end

	set_once_routine_argument (index: INTEGER; routine_name: STRING)
			--
		require
			once_function_exists: routine_table.has (routine_name)
			once_function_takes_no_arguments: routine_table.item (routine_name).item.open_count = 0
			valid_argument: valid_once_routine_argument (index, routine_name)
		local
			once_item: ANY
		do
			if routine_table.has_key (routine_name)
				and then attached {FUNCTION [ANY]} routine_table.found_item.item as function
			then
				function.apply
				once_item := function.last_result
				if routine.arguments.valid_type_for_index (once_item, index) then
					routine.arguments.put (once_item, index)
				else
					set_type_mismatch_error (index, routine_name)
				end
			else
				set_error (Error.once_function_not_found, routine_name)
			end
		end

	set_type_mismatch_error (index: INTEGER; argument: STRING)
		do
			set_error (
				Error.argument_type_mismatch,
				Type_mismatch_error_template #$ [argument, routine.argument_types.item (index).name]
			)
		end

	valid_once_routine_argument (index: INTEGER; routine_name: STRING): BOOLEAN
		do
			if routine_table.has_key (routine_name)
				and then attached {FUNCTION [ANY]} routine_table.found_item.item as function
			then
				function.apply
				Result := routine.arguments.valid_type_for_index (function.last_result, index)
			end
		end

feature {NONE} -- Internal attributes

	argument_list: EL_STRING_8_LIST
		-- list of routine request arguments

	string_result: EROS_STRING_RESULT

	routine: EROS_ROUTINE
		-- requested routine

feature {NONE} -- Constants

	Default_routine: EROS_ROUTINE
		once ("PROCESS")
			create Result.make ("default", agent do_nothing)
		end

	Type_mismatch_error_template: ZSTRING
			--
		once
			Result := "Cannot convert argument %"%S%" to type %S"
		end

	Procedure_acknowledgement: EROS_PROCEDURE_STATUS
			--
		once
			create Result.make
		end

feature {NONE} -- String constants

	Curly_braces: STRING = "{}"

end