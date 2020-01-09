note
	description: "Remote call constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-09 18:37:55 GMT (Thursday 9th January 2020)"
	revision: "6"

class
	EL_REMOTE_CALL_CONSTANTS

feature {NONE} -- Commands

	Command_quit: STRING = "quit"

	Command_set_error: STRING = "set_error"

feature {NONE} -- Error codes

	Error_argument_type_mismatch: INTEGER = 5

	Error_class_name_not_found: INTEGER = 2

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

	Error_once_function_not_found: INTEGER = 6

	Error_routine_not_found: INTEGER = 4

	Error_syntax_error_in_routine_call: INTEGER = 1

	Error_wrong_number_of_arguments: INTEGER = 3


feature {NONE} -- Routine names

	R_set_stopping: STRING = "set_stopping"

	R_set_inbound_type: STRING = "set_inbound_type"

	R_set_outbound_type: STRING = "set_outbound_type"

feature {NONE} -- Constants

	Client_classname_suffix: STRING = "_PROXY"

	Event_source: EL_HASH_TABLE [TYPE [EL_PARSE_EVENT_SOURCE], INTEGER]
		once
			create Result.make (<<
				[Type_binary,		{EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE}],
				[Type_plaintext,	{EL_EXPAT_XML_WITH_CTRL_Z_PARSER}]
			>>)
		end

	Event_source_name: EL_HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (<<
				[Type_binary,		"binary"],
				[Type_plaintext,	"plaintext"]
			>>)
		end

	Type_binary: INTEGER = 2

	Type_plaintext: INTEGER = 1

end
