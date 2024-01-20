note
	description: "[
		A command line interface to the class ${TB_MULTI_LANG_ACCOUNT_BOOK_EXPORTER}.
		
		This application takes one argument `-config' which is a path to a Thunderbird export
		configuration file.
		
		The application merges a localized folder of emails in the Thunderbird email client into a
		single HTML book with chapter numbers and titles derived from subject line.
		The output files are used to generate a Kindle book.
		
		See class ${TB_MULTI_LANG_ACCOUNT_BOOK_EXPORTER} for configuration example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "14"

class
	THUNDERBIRD_BOOK_EXPORTER_APP

inherit
	THUNDERBIRD_ACCOUNT_READER_APP [TB_MULTI_LANG_ACCOUNT_BOOK_EXPORTER]
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