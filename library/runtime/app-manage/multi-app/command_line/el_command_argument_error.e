note
	description: "${EL_ERROR_DESCRIPTION} for command line argument errors"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-15 16:40:37 GMT (Thursday 15th February 2024)"
	revision: "16"

class
	EL_COMMAND_ARGUMENT_ERROR

inherit
	EL_ERROR_DESCRIPTION
		rename
			id as word_option
		end

create
	make, make_empty

feature -- Element change

	set_invalid_argument (a_message: ZSTRING)
		do
			set_lines (Template.invalid_argument #$ [word_option, a_message])
		end

	set_missing_argument
		do
			set_lines (Template.missing_argument #$ [word_option])
		end

	set_no_default_argument
		do
			set_lines (Template.missing_argument #$ [word_option])
		end

	set_path_error (a_path: EL_PATH)
		do
			set_lines (Template.path_error #$ [word_option, a_path.type_alias, a_path.type_alias, a_path])
		end

	set_required_error
		do
			set_lines (Template.required_argument #$ [word_option])
		end

	set_type_error (type_name: ZSTRING)
		do
			set_lines (Template.type_error #$ [word_option, type_name])
		end

feature {NONE} -- Constants

	Template: TUPLE [
		invalid_argument, missing_argument, no_default_argument, path_error,
		required_argument, type_error: ZSTRING
	]
		once
			create Result
			Result.invalid_argument := "[
				ERROR: Invalid value for '-#' argument
				#
			]"
			Result.missing_argument:= "[
				The word option `-#' is not followed by an argument.
			]"
			Result.no_default_argument:= "[
				The word option `-#' does not have a default.
			]"
			Result.path_error := "[
				ERROR in `-#' # path argument
				The #: "#" does not exist.
			]"
			Result.required_argument := "[
				A required argument `-#' is not specified.
			]"
			Result.type_error := "[
				ERROR: option `-#' is not followed by a #
			]"
		end

end