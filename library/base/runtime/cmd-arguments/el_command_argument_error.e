note
	description: "Object containing description of an error in a command line argument"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 11:37:28 GMT (Monday 5th August 2019)"
	revision: "7"

class
	EL_COMMAND_ARGUMENT_ERROR

inherit
	ANY
	
	EL_ZSTRING_CONSTANTS

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_word_option: like word_option)
		do
			make_default
			word_option := a_word_option
		end

	make_default
		do
			word_option := Empty_string
			create description.make_empty
		end

feature -- Access

	description: EL_ZSTRING_LIST

	word_option: READABLE_STRING_GENERAL

feature -- Basic operations

	print_to_lio
		do
			lio.put_new_line
			across description as line loop
				lio.put_line (line.item)
			end
		end

feature -- Element change

	set_invalid_argument (a_message: ZSTRING)
		do
			set_lines (Template.invalid_argument #$ [word_option, a_message])
		end

	set_lines (a_string: ZSTRING)
		do
			create description.make_with_lines (a_string)
		end

	set_missing_argument
		do
			set_lines (Template.missing_argument #$ [word_option])
		end

	set_path_error (path_type: ZSTRING; a_path: EL_PATH)
		do
			set_lines (Template.path_error #$ [path_type, word_option, path_type, a_path])
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

	Template: TUPLE [invalid_argument, missing_argument, path_error, required_argument, type_error: ZSTRING]
		once
			create Result
			Result.missing_argument:= "[
				The word option "-#" is not followed by an argument.
			]"
			Result.invalid_argument := "[
				ERROR: Invalid value for "-#"
				#
			]"
			Result.path_error := "[
				ERROR in # argument: "-#"
				The #: "#" does not exist.
			]"
			Result.required_argument := "[
				A required argument "-#" is not specified.
			]"
			Result.type_error := "[
				ERROR: option "-#" is not followed by a #
			]"
		end

end
