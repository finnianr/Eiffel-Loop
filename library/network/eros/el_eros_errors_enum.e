note
	description: "Eros errors enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 20:11:31 GMT (Monday 13th January 2020)"
	revision: "1"

class
	EL_EROS_ERRORS_ENUM

inherit
	EL_DESCRIPTIVE_ENUMERATION [NATURAL_8]
		rename
			export_name as export_default,
			import_name as import_default
		end

create
	make

feature -- Access

	argument_type_mismatch: NATURAL_8

	invalid_type: NATURAL_8

	once_function_not_found: NATURAL_8

	routine_not_found: NATURAL_8

	syntax_error_in_routine_call: NATURAL_8

	wrong_number_of_arguments: NATURAL_8

feature {NONE} -- Constants

	Descriptions: STRING = "[
		syntax_error_in_routine_call:
			Syntax error in routine call
		error_invalid_type:
			Class name is empty or not a valid type
		wrong_number_of_arguments:
			Wrong number of arguments to routine
		routine_not_found:
			The named routine was not found
		argument_type_mismatch:
			Argument type in processing instruction call and routine tuple do not match
		once_function_not_found:
			Named once function not found in class
	]"
end
