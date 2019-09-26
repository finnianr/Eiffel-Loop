note
	description: "[
		A command line interface to the class [$source EL_ML_THUNDERBIRD_ACCOUNT_BOOK_EXPORTER].
		
		This application takes one argument `-config' which is a path to a Thunderbird export
		configuration file.
		
		The application merges a localized folder of emails in the Thunderbird email client into a
		single HTML book with chapter numbers and titles derived from subject line.
		The output files are used to generate a Kindle book.
		
		See class [$source EL_ML_THUNDERBIRD_ACCOUNT_BOOK_EXPORTER] for configuration example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-25 15:26:18 GMT (Wednesday   25th   September   2019)"
	revision: "5"

class
	THUNDERBIRD_BOOK_EXPORTER_APP

inherit
	EL_LOGGED_COMMAND_LINE_SUB_APPLICATION [EL_ML_THUNDERBIRD_ACCOUNT_BOOK_EXPORTER]
		redefine
			option_name
		end

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("config", "Thunderbird export configuration file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make_from_file ("")
		end

feature {NONE} -- Constants

	Description: STRING = "Export emails from Thunderbird folders as HTML books"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{THUNDERBIRD_BOOK_EXPORTER_APP}, All_routines]
			>>
		end

	Option_name: STRING = "export_book"
end
