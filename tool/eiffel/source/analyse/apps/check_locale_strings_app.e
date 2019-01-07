note
	description: "[
		A command line interface to the command [$source CHECK_LOCALE_STRINGS_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-23 16:20:18 GMT (Sunday 23rd December 2018)"
	revision: "5"

class
	CHECK_LOCALE_STRINGS_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [CHECK_LOCALE_STRINGS_COMMAND]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("config", "Configuration file path", << file_must_exist >>),
				optional_argument ("language", "Language code to check")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", "en")
		end

feature {NONE} -- Constants

	Option_name: STRING = "check_locale_strings"

	Description: STRING = "Check that every locale string can be found in given locale"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{CHECK_LOCALE_STRINGS_APP}, All_routines]
			>>
		end

end