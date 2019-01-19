note
	description: "[
		Multi-lingual (ML) Thunderbird account book exporter.
		
		Merge localized folder of emails into a single HTML book with chapter numbers
		and titled derived from subject line.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:31:08 GMT (Friday 18th January 2019)"
	revision: "4"

class
	EL_ML_THUNDERBIRD_ACCOUNT_BOOK_EXPORTER

inherit
	EL_ML_THUNDERBIRD_ACCOUNT_READER
		redefine
			make_default, building_action_table
		end

	EL_STRING_8_CONSTANTS

create
	make_from_file

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create book.make_default
		end

feature -- Access

	book: EL_BOOK_INFO

feature {NONE} -- Implementation

	new_reader: EL_THUNDERBIRD_BOOK_EXPORTER
		do
			create Result.make (Current)
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			Result := Precursor + ["kindle-book", agent do set_next_context (book) end]
		end
end
