note
	description: "Manage command-line arguments for application and command option help"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 2:31:46 GMT (Friday 25th January 2019)"
	revision: "1"

class
	EL_APPLICATION_ARGUMENTS

inherit
	EL_MODULE_ARGS

feature {NONE} -- Initialization

	make
			--
		do
			create options_help.make (11)
			create argument_errors.make (0)
		end

feature -- Access

	argument_errors: ARRAYED_LIST [EL_COMMAND_ARGUMENT_ERROR]

	options_help: EL_SUB_APPLICATION_HELP_LIST

feature -- Status query

	ask_user_to_quit: BOOLEAN
			--
		do
			Result := Args.word_option_exists ({EL_COMMAND_OPTIONS}.Ask_user_to_quit)
		end

	command_line_help_option_exists: BOOLEAN
		do
			-- Args.character_option_exists ({EL_COMMAND_OPTIONS}.Help [1]) or else
			-- This doesn't work because of a bug in {ARGUMENTS_32}.option_character_equal
			Result := Args.word_option_exists ({EL_COMMAND_OPTIONS}.Help)
		end

	has_argument_errors: BOOLEAN
		do
			Result := not argument_errors.is_empty
		end

feature -- Element change

	set_boolean_from_command_opt (a_bool: BOOLEAN_REF; a_word_option, a_description: READABLE_STRING_GENERAL)
		do
			if a_bool.item and then Args.word_option_exists (a_word_option) then
				a_bool.set_item (False)
			else
				a_bool.set_item (Args.word_option_exists (a_word_option))
			end
			options_help.extend (a_word_option, a_description, False)
		end

feature {NONE} -- Factory routines

	new_argument_error (option: READABLE_STRING_GENERAL): EL_COMMAND_ARGUMENT_ERROR
		do
			create Result.make (option)
		end

feature {NONE} -- Implementation

	standard_options: EL_HASH_TABLE [STRING, STRING]
		-- Standard command line options
		do
			create Result.make (<<
				[{EL_COMMAND_OPTIONS}.No_highlighting, 	"Turn off color highlighting for console output"],
				[{EL_COMMAND_OPTIONS}.No_app_header, 		"Suppress output of application information"],
				[{EL_COMMAND_OPTIONS}.silent, 				"Suppress all output to console"],
				[{EL_COMMAND_OPTIONS}.Ask_user_to_quit, 	"Prompt user to quit before exiting application"]
			>>)
		end

end
