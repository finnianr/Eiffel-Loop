note
	description: "Comma separated import test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-25 15:02:55 GMT (Saturday 25th June 2022)"
	revision: "17"

class
	COMMA_SEPARATED_IMPORT_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_CRC_32_TEST_ROUTINES

	EL_MODULE_LOG

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("import_export", agent test_import_export)
		end

feature -- Test

	test_import_export
			--
		note
			testing: "covers/{CSV_IMPORTABLE_ARRAYED_LIST}.import",
				"covers/{CSV_LINE_PARSER}.parse",
				"covers/{EL_COMMA_SEPARATED_VALUE_ESCAPER}.escaped",
				"covers/{EL_REFLECTIVELY_SETTABLE}.comma_separated_values"
		do
			if attached new_job_list as job_list then
				do_import_test (job_list)
				do_test ("do_export_test", 3825742947, agent do_export_test, [job_list])
			end
		end

feature {NONE} -- Implementation

	do_export_test (job_list: like new_job_list)
		local
			parser: CSV_LINE_PARSER
			job, job_2: JOB; list: EL_ZSTRING_LIST
		do
			job_list.find_first_true (agent role_contains (?, "Change Manager"))
			job := job_list.item

			create parser.make
			parser.parse (job.comma_separated_names)
			create list.make_comma_split (job.comma_separated_values)
			across list as value loop
				if value.item.count > 140 then
					log.put_string_field_to_max_length ("LONG", value.item, 140)
					log.put_new_line
				else
					log.put_line (value.item)
				end
			end
			parser.parse (job.comma_separated_values)

			create job_2.make_default
			parser.set_object (job_2)
			assert ("jobs equal", job ~ job_2)
		end

	do_import_test (job_list: like new_job_list)
		do
			assert ("Type is Contract x 2", job_list.count_of (agent is_type (?, "Contract")) = 2)
			assert ("Role contains Manager x 2", job_list.count_of (agent role_contains (?, "Manager")) = 2)
			assert ("telephone_1 is  x 3", job_list.count_of (agent telephone_1_starts (?, "0208")) = 3)

			job_list.find_first_true (agent role_contains (?, "Change Manager"))
			assert ("12 double quotes in description", job_list.item.description.occurrences ('"') = 12)
			assert ("3 new-lines description", job_list.item.description.occurrences ('%N') = 3)
		end

	is_type (job: JOB; name: STRING): BOOLEAN
		do
			Result := job.type ~ name
		end

	new_job_list: CSV_IMPORTABLE_ARRAYED_LIST [JOB]
		do
			create Result.make (10)
			Result.import_csv_latin_1 ("data/csv/JobServe.csv")
		end

	role_contains (job: JOB; word: STRING): BOOLEAN
		do
			Result := job.role.has_substring (word)
		end

	telephone_1_starts (job: JOB; a_prefix: STRING): BOOLEAN
		do
			Result := job.telephone_1.starts_with (a_prefix)
		end

end