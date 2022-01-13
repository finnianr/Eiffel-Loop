note
	description: "[
		A command line interface to the command [$source CHECK_LOCALE_STRINGS_COMMAND].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 12:23:37 GMT (Thursday 13th January 2022)"
	revision: "9"

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
				valid_required_argument ("config", "Configuration file path", << file_must_exist >>),
				optional_argument ("language", "Language code to check")
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