note
	description: "[
		An application for verifying localization translation identifiers against various kinds of source texts
		See [$source CHECK_LOCALE_STRINGS_COMMAND] for details.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHECK_LOCALE_STRINGS_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [CHECK_LOCALE_STRINGS_COMMAND]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [config_path: EL_FILE_PATH; language: STRING]
		do
			create Result
			Result.config_path := ""
			Result.language := "en"
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("config", "Configuration file path", << file_must_exist >>),
				optional_argument ("language", "Language code to check")
			>>
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
