note
	description: "[
		Command line options for `app-manage.ecf' library accessible from [$source EL_SHARED_APPLICATION_OPTION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-31 12:05:49 GMT (Tuesday 31st December 2019)"
	revision: "1"

class
	EL_APPLICATION_COMMAND_OPTIONS

inherit
	EL_COMMAND_LINE_OPTIONS

	EL_MODULE_TUPLE

create
	make

feature -- Access

	ask_user_to_quit: BOOLEAN
		-- `True' if command line option of same name exists
		-- Prompt user to quit when sub-application finishes (EL_SUB_APPLICATION)

	help: BOOLEAN
		-- `True' if command line option of same name exists
		-- Args.character_option_exists ({EL_COMMAND_OPTIONS}.Help [1]) or else
		-- This doesn't work because of a bug in {ARGUMENTS_32}.option_character_equal

	no_app_header: BOOLEAN
		-- `True' if command line option of same name exists

feature -- Constants

	sub_app: TUPLE [install, remove_data, silent, uninstall: STRING]
		once
			create Result
			Tuple.fill (Result, "install, remove_data, silent, uninstall")
		end

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
			]"
		end

end
