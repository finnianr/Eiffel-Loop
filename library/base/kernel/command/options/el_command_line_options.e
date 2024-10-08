note
	description: "[
		Base class for reflectively settable command line options with associated help texts
	]"
	notes: "See end of class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-15 7:26:18 GMT (Thursday 15th August 2024)"
	revision: "31"

deferred class
	EL_COMMAND_LINE_OPTIONS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		export
			{NONE} all
			{ANY} print_fields
		end

	EL_REFLECTIVE_DESCRIPTIONS
		rename
			descriptions as help_text,
			description_table as help_table,
			valid_description_table as valid_help_table
		end

	EL_MAKEABLE
		rename
			make as make_default
		undefine
			is_equal
		end

	EL_MODULE_ARGS; EL_MODULE_TUPLE

feature {NONE} -- Initialization

	make
		-- make object with attributes initialized from corresponding command line options
		do
			make_default
			Args.set_attributes (Current)
		ensure
			valid_help: not help_text.is_empty implies valid_help_table
		end

feature {NONE} -- Implementation

	joined (precursor_lines, lines: STRING): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.joined_list (<< precursor_lines, lines >>,'%N')
		end

note
	descendants: "[
			EL_COMMAND_LINE_OPTIONS*
				${EL_APPLICATION_COMMAND_OPTIONS}
					${EROS_APPLICATION_COMMAND_OPTIONS}
					${FTP_LOGIN_OPTIONS}
					${INTEGRATION_COMMAND_OPTIONS}
				${EL_BASE_COMMAND_OPTIONS}
				${EL_LOG_COMMAND_OPTIONS}
	]"
	notes: "[
		Each class attribute maps to a command line word option of the same name.
		For `BOOLEAN' attributes, if the word-option exists, the attibute is set to `True'
		For other types, the value is set to the next command line argument following the
		word option.

		**Default values**

		Redefine `initialize_fields' to set default values. Ensure the class is createable as follows
		to allow the correct generation of help text.

			create
				make, make_default

		**Help Text**

		The `help_table' function converts the text from `help_text' into a table of tuples each
		containing a description and the default value. A usage example can be seen in
		command line help system found in class ${EL_APPLICATION}.

		If the help text is not implemented as an empty string, then it should be formatted as
		a series of option names ending with `:', and the description indented by 1 tab on the next
		line. See ${EL_BASE_COMMAND_OPTIONS} for an example.

		Use the `joined' function to join `Help_text' with it's precursor.
	]"

end