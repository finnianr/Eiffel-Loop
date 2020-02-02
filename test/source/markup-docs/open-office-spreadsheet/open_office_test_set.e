note
	description: "Evaluates tests in [$source VTD_XML_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-02 9:30:44 GMT (Sunday 2nd February 2020)"
	revision: "15"

class
	OPEN_OFFICE_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

feature -- Tests

	test_read_row_cells
		local
			jobs: EL_SPREAD_SHEET
		do
			create jobs.make ("XML/Jobs-spreadsheet.fods")
			do_test ("read_spreadsheet", 0, agent read_spreadsheet, [jobs])
		end

feature {NONE} -- Implementation

	read_spreadsheet (spread_sheet: EL_SPREAD_SHEET)
		local
			data_cell: EL_SPREAD_SHEET_DATA_CELL
		do
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
