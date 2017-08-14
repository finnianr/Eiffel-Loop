note
	description: "Summary description for {CHECK_LOCALE_STRINGS_APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_CHECK_LOCALE_STRINGS_APP

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [EL_CHECK_LOCALE_STRINGS_COMMAND]
		redefine
			Option_name
		end

	EL_SHARED_LOCALE_TABLE

create
	make

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [path: EL_DIR_PATH; include_path: EL_FILE_PATH; language: STRING]
		do
			create Result
			Result.path := "source"
			Result.include_path := ""
			Result.language := "en"
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				required_argument ("source", "Source tree directory path"),
				valid_optional_argument ("include", "List of extra files to include", << file_must_exist >>),
				valid_optional_argument ("language", "Language code to check",
					<< ["locale.<language> file must exist", agent Locale_table.has] >>
				)
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "check_locale_strings"

	Description: STRING = "Check that every locale string can be found in given locale"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{EL_CHECK_LOCALE_STRINGS_APP}, All_routines]
			>>
		end

end
