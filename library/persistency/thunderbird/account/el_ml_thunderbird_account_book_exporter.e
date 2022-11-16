note
	description: "[
		Multi-lingual (ML) Thunderbird account book exporter.
		
		Merge localized folder of emails into a single HTML book with chapter numbers
		and titled derived from subject line.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

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

feature -- Constants

	Description: STRING = "Export merged email chapters from Thunderbird folders as HTML book"

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

note
	notes: "[
		The configuration file for generating a Kindle book is written in Pyxis format.
		
		**Example**
		
			pyxis-doc:
				version = 1.0; encoding = "ISO-8859-1"

			thunderbird:
				account = "pop.myching.co"; export_dir = "workarea/content-main"; language = en

				folders:
					"Manual"

				kindle-book:
					title:
						"The My Ching Manual: The complete guide to using the I Ching journal software and hexagram reference"
					description:
						"Reference manual for the My Ching journal software developed by Hex 11 Software"
					cover-image-path:
						"image/kindle-cover.png"
					author:
						"Reilly, Finnian"
					creator:
						"Hex 11 Software"
					publisher:
						"Hex 11 Software"
					uuid:
						"39880922-D84B-11E8-9D6F-A759E74D277D"
					language:
						"en-US"
					subject-heading:
						"Reference"
					publication-date:
						"2018-12-01"
	]"
end