note
	description: "Summary description for {BENCHMARK_STRINGS_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-24 15:21:39 GMT (Wednesday 24th July 2013)"
	revision: "3"

class
	BENCHMARK_STRINGS_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_TESTABLE_APPLICATION

	EL_MODULE_ENVIRONMENT

	EL_MODULE_STRING

	EL_MODULE_TYPING

	EL_SHARED_CODEC

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
			create run_number
			create spread_sheet_file_path
			create output_dir
			Args.set_integer_from_word_option ("run", agent run_number.set_item, 1)
			Args.set_string_from_word_option ("file", agent spread_sheet_file_path.set_path, "")
			Args.set_string_from_word_option ("d", agent output_dir.set_path, "")
			load_data
		end

feature -- Basic operations

	normal_run
			--
		local
			csv_file: PLAIN_TEXT_FILE
			routines: ARRAYED_LIST [STRING]
			results: ARRAY2 [STRING]
			test_type: STRING_TESTS [STRING_GENERAL]
			row, column: INTEGER
			file_name: STRING
			l_codec: EL_CODEC
		do
			log.enter ("run")
			create {STRING_32_TESTS} test_type.make (string_list)
			routines := test_type.routines
			create results.make (routines.count + 3, 5)
			results.put ("ROUTINES", 1, 1)
			results.put ("TOTAL TIMES (ms)", routines.count + 2, 1)
			results.put ("TOTAL STORAGE (mb)", routines.count + 3, 1)
			across routines as name loop
				results.put (name.item, name.cursor_index + 1, 1)
			end

			transpose_results (2, test_type, results)

			set_codec (create {EL_ISO_8859_1_CODEC}.make)
			create {EL_ASTRING_TESTS} test_type.make (string_list)
			transpose_results (3, test_type, results)

			set_codec (create {EL_ISO_8859_15_CODEC}.make)
			create {EL_ASTRING_TESTS} test_type.make (string_list)
			transpose_results (4, test_type, results)

			create {UC_UTF8_STRING_TESTS} test_type.make (string_list)
			transpose_results (5, test_type, results)

			file_name := "string-types-test-results.v$V.csv"
			file_name.replace_substring_all ("$V", run_number.out)
			create csv_file.make_open_write ((output_dir + file_name).unicode)
			from row := 1 until row > results.height loop
				from column := 1 until column > results.width loop
					if column > 1 then
						csv_file.put_character (',')
					end
					csv_file.put_string (results [row, column])
					column := column + 1
				end
				csv_file.put_new_line
				row := row + 1
			end
			csv_file.close
			log.exit
		end

feature -- Testing

	test_run
			--
		do
			Test.do_file_test ("XML/Jobs-spreadsheet.fods", agent test_strings, 2406301618)
		end

	test_strings (file_path: EL_FILE_PATH)
		do
			run_number := 1
			output_dir := file_path.parent
			spread_sheet_file_path := file_path
			load_data
			normal_run
		end

feature {NONE} -- Implementation

	transpose_results (column: INTEGER; type: STRING_TESTS [STRING_GENERAL]; results: ARRAY2 [STRING])
		do
			results.put (type.name, 1, column)
			across type.results_ms as time_ms loop
				results.put (time_ms.item.out, 1 + time_ms.cursor_index, column)
			end
			results.put (type.total_time_ms.out, 2 + type.results_ms.count, column)
			results.put (type.total_mega_bytes.out, 3 + type.results_ms.count, column)
		end

	load_data
		local
			jobs_fods: EL_SPREAD_SHEET
		do
			log.enter ("load_data")
			create jobs_fods.make (spread_sheet_file_path)
			create string_list.make (jobs_fods.count * 5)
			across jobs_fods.first_table as row loop
				across row as cell loop
					if not cell.item.is_empty then
						string_list.extend (cell.item.i_th (1).text.to_unicode)
					end
				end
			end
			log.exit
		end

	spread_sheet_file_path: EL_FILE_PATH

	output_dir: EL_DIR_PATH

	string_list: ARRAYED_LIST [STRING_32]

	run_number: INTEGER_REF

feature {NONE} -- Constants

	Option_name: STRING = "benchmark_strings"

	Description: STRING = "Benchmark performance of various string types"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{BENCHMARK_STRINGS_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{EL_SPREAD_SHEET}, "*"],

				[{STRING_32_TESTS}, "*"],
				[{EL_ASTRING_TESTS}, "*"],
				[{UC_UTF8_STRING_TESTS}, "*"]
			>>
		end

end
