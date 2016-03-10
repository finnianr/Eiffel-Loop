note
	description: "Summary description for {EL_REMOTE_CALL_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_REMOTE_CALL_CONSTANTS

feature -- Commands

	Command_set_error: STRING = "set_error"

	Command_quit: STRING = "quit"

feature -- Error codes

	Error_syntax_error_in_routine_call: INTEGER = 1

	Error_class_name_not_found: INTEGER = 2

	Error_wrong_number_of_arguments: INTEGER = 3

	Error_routine_not_found: INTEGER = 4

	Error_argument_type_mismatch: INTEGER = 5

	Error_once_function_not_found: INTEGER = 6

	Error_messages: ARRAY [STRING]
			--
		once
			create Result.make (1, Error_once_function_not_found)
			Result [Error_syntax_error_in_routine_call] := "Syntax error in routine call"
			Result [Error_class_name_not_found] := "No class of that name to service request"
			Result [Error_wrong_number_of_arguments] := "Wrong number of arguments to routine"
			Result [Error_routine_not_found] := "Function not found"
			Result [Error_argument_type_mismatch] := "Argument type in processing instruction call and routine tuple do not match"
			Result [Error_once_function_not_found] := "Once function not found in class"
		end

feature -- Constants

	Client_classname_suffix: STRING = "_PROXY"

	Transmission_type_plaintext: INTEGER = 1

	Transmission_type_binary: INTEGER = 2

end
