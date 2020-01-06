note
	description: "Test Open Office classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-14 9:31:41 GMT (Friday 14th June 2019)"
	revision: "8"

class
	OPEN_OFFICE_TEST_APP

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		undefine
			test_data_dir
		redefine
			Option_name, initialize, visible_types
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS
		rename
			Build_info as EL_build_info,
			EL_test_data_dir as test_data_dir
		end

	EL_MODULE_EXCEPTION

	EL_MODULE_OS

	EL_MODULE_XML

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			log.enter ("initialize")
			Precursor
			create root_node
			log.exit
		end

	normal_initialize
		do
		end

feature -- Basic operations

	normal_run
		do
		end

	test_run
		do
			log.enter ("test_run")
			Test.do_file_test ("XML/Jobs-spreadsheet.fods", agent read_jobs_spreadsheet, 2295406679) -- Has a bug
			log.exit
		end

feature {NONE} -- Tests

	read_jobs_spreadsheet (file_path: EL_FILE_PATH)
		local
			jobs: EL_SPREAD_SHEET
			data_cell: EL_SPREAD_SHEET_DATA_CELL
		do
			log.enter ("read_jobs_spreadsheet")
			create jobs.make ("XML/Jobs-spreadsheet.fods")
			across jobs as table loop
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
			log.exit
		end


feature {NONE} -- Implementation

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{OPEN_OFFICE_TEST_APP}, All_routines]
			>>
		end

	visible_types: TUPLE [EL_SPREAD_SHEET_TABLE]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Internal attributes

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

feature {NONE} -- Constants

	Description: STRING = "Test Open Office spread sheet parser"

	Option_name: STRING = "test_spread_sheet"

end
