note
	description: "[
		Command line options for `app-manage.ecf' library accessible from ${EL_SHARED_APPLICATION_OPTION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-17 19:15:03 GMT (Sunday 17th March 2024)"
	revision: "12"

class
	EL_APPLICATION_COMMAND_OPTIONS

inherit
	EL_COMMAND_LINE_OPTIONS
		redefine
			make_default
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			make_solitary
			Precursor
		end

feature -- Access

	ask_user_to_quit: BOOLEAN
		-- `True' if command line option of same name exists
		-- Prompt user to quit when sub-application finishes (EL_APPLICATION)

	help: BOOLEAN
		-- `True' if command line option of same name exists
		-- Args.character_option_exists ({EL_COMMAND_OPTIONS}.Help [1]) or else
		-- This doesn't work because of a bug in {ARGUMENTS_32}.option_character_equal

	no_app_header: BOOLEAN
		-- `True' if command line option of same name exists

	pause_on_error: BOOLEAN
		-- when `True' user will be prompted to quit after displaying error message

	test: BOOLEAN

	test_set: STRING
		-- test to run from EL_AUTOTEST_APPLICATION

	show_benchmarks: BOOLEAN

feature {NONE} -- Constants

	Help_text: STRING
		once
			Result := "[
				ask_user_to_quit:
					Prompt user to quit before exiting application
				help:
					Show application help
				no_app_header:
					Suppress output of application information
				pause_on_error:
					Prompt user to quit after displaying error message
				show_benchmarks:
					As application exits, show execution time and average execution time since last version update
				test:
					Put application in test mode (if testable)
				test_set:
					Name of EQA test set to evaluate. Optionally execute a single test by appending '.'
					and name of test: Eg. MY_TESTS.test_something. The "test_" prefix is optional.
			]"
		end

end