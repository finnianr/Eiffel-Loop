note
	description: "[
		A command line interface to the command ${CHECK_LOCALE_STRINGS_COMMAND}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "17"

class
	CHECK_LOCALE_STRINGS_APP

obsolete
	"Use EL_LOCALIZATION_TEST with EL_REFLECTIVE_LOCALE_TEXTS"

inherit
	EL_COMMAND_LINE_APPLICATION [CHECK_LOCALE_STRINGS_COMMAND]
		undefine
			make_solitary
		redefine
			Option_name
		end

	EL_LOCALIZED_APPLICATION
		redefine
			new_locale
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				config_argument (Void),
				optional_argument ("language", "Language code to check", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "en")
		end

	new_locale: EL_ENGLISH_DEFAULT_LOCALE
		do
			create Result.make_resources
		end

feature {NONE} -- Constants

	Option_name: STRING = "check_locale_strings"

end