note
	description: "Enumeration EROS server error"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-13 8:24:44 GMT (Sunday 13th August 2023)"
	revision: "7"

class
	EROS_ERRORS_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			foreign_naming as eiffel_naming
		redefine
			Description_table
		end

create
	make

feature -- Access

	argument_type_mismatch: NATURAL_8

	invalid_type: NATURAL_8

	invalid_result: NATURAL_8

	once_function_not_found: NATURAL_8

	routine_not_found: NATURAL_8

	syntax_error_in_routine_call: NATURAL_8

	wrong_number_of_arguments: NATURAL_8

feature {NONE} -- Constants

	Description_table: EL_IMMUTABLE_UTF_8_TABLE
		once
			create Result.make ("[
				argument_type_mismatch:
					Argument type in processing instruction call and routine tuple do not match
				invalid_type:
					Class name is empty or not a valid type
				invalid_result:
					Call result is void
				syntax_error_in_routine_call:
					Syntax error in routine call
				routine_not_found:
					The named routine was not found
				once_function_not_found:
					Named once function not found in class
				wrong_number_of_arguments:
					Wrong number of arguments to routine
			]")
		end
end