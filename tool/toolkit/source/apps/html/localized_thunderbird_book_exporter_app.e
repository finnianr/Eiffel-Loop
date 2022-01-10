note
	description: "[
		Merge localized folder of emails into a single HTML book with chapter numbers
		and titled derived from subject line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-10 15:31:05 GMT (Monday 10th January 2022)"
	revision: "7"

class
	LOCALIZED_THUNDERBIRD_BOOK_EXPORTER_APP

inherit
	THUNDERBIRD_ACCOUNT_READER_APP [EL_ML_THUNDERBIRD_ACCOUNT_BOOK_EXPORTER]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make_from_file ("")
		end

feature {NONE} -- Constants

	Description: STRING = "Export merged email chapters from Thunderbird folders as HTML book"

	Option_name: STRING = "export_thunderbird_book"
end