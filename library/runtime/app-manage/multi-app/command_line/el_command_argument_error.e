note
	description: "${EL_ERROR_DESCRIPTION} for command line argument errors"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-20 10:35:31 GMT (Wednesday 20th March 2024)"
	revision: "18"

class
	EL_COMMAND_ARGUMENT_ERROR

inherit
	EL_ERROR_DESCRIPTION
		rename
			id as word_option
		redefine
			initialize, print_to
		end

create
	make, make_empty

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create argument.make_empty
		end

feature -- Access

	argument: ZSTRING

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

	Error: ZSTRING
		once
			Result := "ERROR"
		end

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
				ERROR: in `-#' # path argument
				The #: "#" does not exist.
			]"
			Result.required_argument := "[
				A required argument `-#' is not specified.
			]"
			Result.type_error := "[
				ERROR: option `-#' is not followed by a #
			]"
		end

feature -- Basic operations

	print_to (log: EL_LOGGABLE)
		do
			if argument.count > 0 then
				log.put_labeled_string ("OPTION -" + word_option, argument)
			else
				log.put_labeled_string (Error, hyphen + word_option + " option")
			end
			log.put_new_line
			across Current as list loop
				if attached list.item as l_line then
					if l_line.starts_with (Error) and then l_line.count > Error.count
						and then l_line [Error.count + 1] = ':'
					then
						log.put_labeled_string (Error, l_line.substring_end (Error.count + 3))
						log.put_new_line
					else
						log.put_line (l_line)
					end
				end
			end
		end

end