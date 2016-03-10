note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-25 19:35:31 GMT (Tuesday 25th June 2013)"
	revision: "2"

class
	STRING_EDITION_HISTORY_TEST_APP

inherit
	TEST_APPLICATION
		redefine
			Option_name, initialize
		end

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			Precursor
			create edition_history.make (10)
		end

feature -- Basic operations

	run
			--
		do
			Test.do_file_test ({STRING_32} "string-edition-list.txt", agent test_editions, 4206604764)
		end

feature -- Tests

	test_editions (file_path: EL_FILE_PATH)
			--
		local
			lines: EL_FILE_LINE_SOURCE
		do
			log.enter ("test_editions")
			create lines.make (file_path)
			across lines as line loop
				log.put_string_field ("string", edition_history.string); log.put_new_line
				edition_history.extend (0, line.item)
			end
			log.put_string_field ("string", edition_history.string); log.put_new_line

			log.put_new_line
			log.put_line ("Undoing edits")
			from until edition_history.is_empty loop
				edition_history.undo
				log.put_string_field ("string", edition_history.string); log.put_new_line
			end
			log.put_new_line
			log.put_line ("Redoing edits")
			from until not edition_history.has_redo_items loop
				edition_history.redo
				log.put_string_field ("string", edition_history.string); log.put_new_line
			end

			log.put_new_line
			log.put_line ("Undoing edits")
			from until edition_history.is_empty loop
				edition_history.undo
				log.put_string_field ("string", edition_history.string); log.put_new_line
			end
			log.exit
		end

feature {NONE} -- Implementation

	edition_history: EL_STRING_EDITION_HISTORY

feature {NONE} -- Constants

	Option_name: STRING = "test_string_edition_history"

	Description: STRING = "Test string edition history"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{STRING_EDITION_HISTORY_TEST_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"]
			>>
		end

end
