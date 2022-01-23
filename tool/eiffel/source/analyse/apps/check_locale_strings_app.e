note
	description: "[
		A command line interface to the command [$source CHECK_LOCALE_STRINGS_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 11:56:04 GMT (Sunday 23rd January 2022)"
	revision: "10"

class
	CHECK_LOCALE_STRINGS_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [CHECK_LOCALE_STRINGS_COMMAND]
		redefine
			Option_name, new_locale
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("config", "Configuration file path", << file_must_exist >>),
				optional_argument ("language", "Language code to check", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "en")
		end

	new_locale: EL_ENGLISH_DEFAULT_LOCALE_IMP
		do
			create Result.make_resources
		end

feature {NONE} -- Constants

	Option_name: STRING = "check_locale_strings"

end