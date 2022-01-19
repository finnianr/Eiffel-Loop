note
	description: "[
		Test classes from library cluster `markup-docs.ecf#open_office'

		* [$source EL_SPREAD_SHEET]
		* [$source EL_SPREAD_SHEET_TABLE]
		* [$source EL_SPREAD_SHEET_ROW]
	]"
	notes: "[
		Test sets conforming to [$source EL_EQA_REGRESSION_TEST_SET] (like this one) can only be run
		from a sub-application conforming to [$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-19 9:45:15 GMT (Wednesday 19th January 2022)"
	revision: "20"

class
	OPEN_OFFICE_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET

	EL_CRC_32_TEST_ROUTINES

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("read_row_cells",	agent test_read_row_cells)
		end

feature -- Tests

	test_read_row_cells
		do
			do_test ("read_spreadsheet", 3625570737, agent read_spreadsheet, ["XML/Jobs-spreadsheet.fods"])
		end

feature {NONE} -- Implementation

	read_spreadsheet (file_path: STRING)
		local
			spread_sheet: EL_SPREAD_SHEET
		do
			create spread_sheet.make (file_path)
			across spread_sheet as table loop
				across table.item as row loop
					log.put_integer_field ("Row", row.cursor_index)
					log.put_string_field (" Type", row.item.cell ("Type").text)
					log.put_string_field (" Title", row.item.cell ("Title").text)
					log.put_new_line
					log.put_integer_field ("Description paragraph count", row.item.cell ("Description").paragraphs.count)
					log.put_new_line
					log.put_new_line
				end
			end
		end

end