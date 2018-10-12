note
	description: "[
		Merge localized folder of emails into a single HTML book with chapter numbers
		and titled derived from subject line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-12 17:15:51 GMT (Friday 12th October 2018)"
	revision: "1"

class
	LOCALIZED_THUNDERBIRD_BOOK_EXPORTER_APP

inherit
	TESTABLE_LOCALIZED_THUNDERBIRD_SUB_APPLICATION [EL_LOCALIZED_THUNDERBIRD_BOOK_EXPORTER]
		redefine
			Option_name
		end

create
	make

feature -- Test

	test_run
			--
		do
			test_config ("pop.myching.co", "en", << "manual" >>, 4293681569)
		end

feature {NONE} -- Implementation

	default_make: PROCEDURE
		do
			Result := agent {like command}.make_from_file ("")
		end

feature {NONE} -- Constants

	Description: STRING = "Export merged emails from Thunderbird folders as HTML books"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{LOCALIZED_THUNDERBIRD_BOOK_EXPORTER_APP}, All_routines]
			>>
		end

	Option_name: STRING = "export_thunderbird_book"
end
