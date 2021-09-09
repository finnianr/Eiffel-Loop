note
	description: "[
		A [$source EL_CAPTURED_OS_COMMAND] with arguments parsed and set in the attribute **var** with type
		defined as a class parameter
	]"
	notes: "[
		The names in **VARIABLES** type must occur in the same order as they do in the **template**
	]"
	descendants: "[
			EL_PARSED_CAPTURED_OS_COMMAND* [VARIABLES -> TUPLE create default_create end]
				[$source EL_MD5_SUM_COMMAND]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 16:33:28 GMT (Thursday 9th September 2021)"
	revision: "2"

deferred class
	EL_PARSED_CAPTURED_OS_COMMAND [VARIABLES -> TUPLE create default_create end]

inherit
	EL_PARSED_OS_COMMAND [VARIABLES]
		undefine
			do_command, make_default, new_command_parts
		end

	EL_CAPTURED_OS_COMMAND
		rename
			template as command_template,
			make as make_command
		export
			{NONE} all
			{ANY} set_working_directory, execute, is_valid_platform, has_error
		undefine
			execute, make_command
		end
end