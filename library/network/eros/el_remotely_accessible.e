note
	description: "Remotely accessible"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 19:34:55 GMT (Monday 13th January 2020)"
	revision: "7"

deferred class
	EL_REMOTELY_ACCESSIBLE

inherit
	EL_ROUTINE_REFLECTIVE
		rename
			make_default as make
		redefine
			make
		end

	EL_MODULE_LOG

	EL_MODULE_STRING_8

	EL_REMOTE_CALL_CONSTANTS

	EL_REMOTE_CALL_ERRORS
		rename
			make_default as make
		redefine
			make
		end

feature {NONE} -- Initialization

	make
			--
		do
			Precursor {EL_ROUTINE_REFLECTIVE}
			Precursor {EL_REMOTE_CALL_ERRORS}
			create routine_table.make (routines)
			create string_result.make
			requested_routine := Default_routine
			create request_arguments
			create request_argument_types.make_empty
			result_object := Procedure_acknowledgement
		end

feature -- Access

	result_object: EVOLICITY_SERIALIZEABLE_AS_XML

feature -- Element change

	set_routine_with_arguments (request_parser: EL_ROUTINE_CALL_REQUEST_PARSER)
			-- set `requested_routine'
		local
			routine_name: STRING; routine_info: EL_ROUTINE_INFO
		do
			log.enter ("set_routine_with_arguments")
			set_error (0)
			set_error_detail ("")
			routine_name := request_parser.routine_name
			if routine_table.has_key (routine_name) then
				requested_routine := routine_table.found_item
				create routine_info.make (routine_name, requested_routine.generating_type)
				request_argument_types := routine_info.argument_types
				request_arguments := requested_routine.empty_operands
				if request_arguments.count = request_parser.argument_list.count then
					set_request_arguments (request_parser)
					requested_routine.set_operands (request_arguments)
				else
					set_error (Error.wrong_number_of_arguments)
					set_error_detail ("should be " + request_arguments.count.out)
				end
			else
				set_error (Error.routine_not_found)
				set_error_detail (routine_name + "?")
				requested_routine := Default_routine
			end
			log.exit
		end

feature -- Basic operations

	call_routine
			--
		require
			no_errors_setting_call_arguments: not has_error
		do
			log.enter ("call_routine")
			if attached {PROCEDURE} requested_routine as procedure then
				procedure.apply
				result_object := Procedure_acknowledgement
			elseif attached {FUNCTION [ANY]} requested_routine as function then
				function.apply
				if attached {EVOLICITY_SERIALIZEABLE_AS_XML} function.last_result as a_result_object then
					result_object := a_result_object

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
			Result := requested_routine /= Default_routine
		end

	function_requested: BOOLEAN
		do
			Result := attached {FUNCTION [ANY]} requested_routine
		end

feature {NONE} -- Implementation

	set_request_arguments (request_parser: EL_ROUTINE_CALL_REQUEST_PARSER)
		local
			argument: STRING; i: INTEGER
			is_convertible: PREDICATE [STRING]
			to_type: FUNCTION [STRING, ANY]
		do
			from i := 1 until i > request_parser.argument_list.count loop
				argument := request_parser.argument_list [i]
				if String_8.has_enclosing (argument, once "''") then
					String_8.remove_single_quote (argument)
					set_string_argument (i, argument)

				elseif String_8.has_enclosing (argument, Curly_braces)
					and then request_parser.has_call_argument
					and then attached {EL_BUILDABLE_FROM_NODE_SCAN} request_parser.call_argument as deserialized_object
				then
					set_deserialized_object_argument (i, argument, deserialized_object)

				elseif Conversion_table.has_key (request_argument_types [i]) then
					is_convertible := Conversion_table.found_item.is_convertible
					to_type := Conversion_table.found_item.to_type
					if is_convertible (argument) then
						request_arguments.put (to_type (argument), i)
					end

				elseif routine_table.has (argument) then
					set_once_routine_argument (i, argument)

				elseif argument.count = 1 then
					set_character_argument (i, argument)
				else
					set_type_mismatch_error (i, argument)
				end
				i := i + 1
			end
		end

	set_character_argument (index: INTEGER; argument: STRING)
		do
			if request_arguments.is_character_8_item (index) then
				request_arguments.put_character_8 (argument [1], index)
			elseif request_arguments.is_character_32_item (index) then
				request_arguments.put_character_32 (argument [1], index)
			else
				set_type_mismatch_error (index, argument)
			end
		end

	set_string_argument (index: INTEGER; argument: STRING)
			--
		require
			valid_argument: request_arguments.valid_type_for_index (argument, index)
		do
			if request_arguments.valid_type_for_index (argument, index) then
				request_arguments.put_reference (argument, index)
			else
				set_type_mismatch_error (index, argument)
			end
		end

	set_deserialized_object_argument (
		index: INTEGER; argument: STRING; argument_object: EL_BUILDABLE_FROM_NODE_SCAN
	)
		require
			valid_argument_object: request_arguments.valid_type_for_index (argument_object, index)
		do
			if request_arguments.valid_type_for_index (argument_object, index) then
				request_arguments.put_reference (argument_object, index)
			else
				set_type_mismatch_error (index, argument)
			end
		end

	set_once_routine_argument (index: INTEGER; routine_name: STRING)
			--
		require
			once_function_exists: routine_table.has (routine_name)
			once_function_takes_no_arguments: routine_table.item (routine_name).open_count = 0
			valid_argument: valid_once_routine_argument (index, routine_name)
		local
			once_item: ANY
		do
			if routine_table.has_key (routine_name)
				and then attached {FUNCTION [ANY]} routine_table.found_item as function
			then
				function.apply
				once_item := function.last_result
				if request_arguments.valid_type_for_index (once_item, index) then
					request_arguments.put (once_item, index)
				else
					set_type_mismatch_error (index, routine_name)
				end
			else
				set_error (Error.once_function_not_found)
				set_error_detail (routine_name)
			end
		end

	set_type_mismatch_error (index: INTEGER; argument: STRING)
		do
			set_error (Error.argument_type_mismatch)
			set_error_detail (Type_mismatch_error_template #$ [argument, request_argument_types.item (index).name])
		end

	valid_once_routine_argument (index: INTEGER; routine_name: STRING): BOOLEAN
		do
			if routine_table.has_key (routine_name)
				and then attached {FUNCTION [ANY]} routine_table.found_item as function
			then
				function.apply
				Result := request_arguments.valid_type_for_index (function.last_result, index)
			end
		end

feature {NONE} -- Internal attributes

	string_result: EL_EROS_STRING_RESULT

	requested_routine: ROUTINE

	request_arguments: TUPLE
		-- arguments for `requested_routine'

	request_argument_types: EL_TUPLE_TYPE_ARRAY

feature {NONE} -- Constants

	Conversion_table: EL_HASH_TABLE [
		TUPLE [is_convertible: PREDICATE [STRING]; to_type: FUNCTION [STRING, ANY]], TYPE [ANY]
	]
		-- string conversion predicates and conversion function
		once
			create Result.make (<<
				[{BOOLEAN},			[agent {STRING}.is_boolean, agent {STRING}.to_boolean]],

				[{INTEGER_8},		[agent {STRING}.is_integer_8, agent {STRING}.to_integer_8]],
				[{INTEGER_16}, 	[agent {STRING}.is_integer_16, agent {STRING}.to_integer_16]],
				[{INTEGER_32},		[agent {STRING}.is_integer_32, agent {STRING}.to_integer_32]],
				[{INTEGER_64},		[agent {STRING}.is_integer_64, agent {STRING}.to_integer_64]],

				[{NATURAL_8},		[agent {STRING}.is_natural_8, agent {STRING}.to_natural_8]],
				[{NATURAL_16},		[agent {STRING}.is_natural_16, agent {STRING}.to_natural_16]],
				[{NATURAL_32},		[agent {STRING}.is_natural_32, agent {STRING}.to_natural_32]],
				[{NATURAL_64},		[agent {STRING}.is_natural_64, agent {STRING}.to_natural_64]],

				[{DOUBLE},			[agent {STRING}.is_double, agent {STRING}.to_double]],
				[{REAL},				[agent {STRING}.is_real, agent {STRING}.to_real]]
			>>)
		end

	Default_routine: ROUTINE
		once ("PROCESS")
			Result := agent do_nothing
		end

	Type_mismatch_error_template: ZSTRING
			--
		once
			Result := "Cannot convert argument %"%S%" to type %S"
		end

	Procedure_acknowledgement: EL_EROS_PROCEDURE_STATUS
			--
		once
			create Result.make
		end

feature {NONE} -- String constants

	Curly_braces: STRING = "{}"

end
