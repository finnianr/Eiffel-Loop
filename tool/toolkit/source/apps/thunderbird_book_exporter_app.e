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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	THUNDERBIRD_BOOK_EXPORTER_APP

inherit
	THUNDERBIRD_ACCOUNT_READER_APP [EL_ML_THUNDERBIRD_ACCOUNT_BOOK_EXPORTER]
		redefine
			option_name
		end

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make_from_file (create {FILE_PATH})
		end

feature {NONE} -- Constants

	Option_name: STRING = "export_book"
	
end