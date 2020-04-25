note
	description: "Comma separated import test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-25 10:42:20 GMT (Saturday 25th April 2020)"
	revision: "9"

class
	COMMA_SEPARATED_IMPORT_TEST_SET

inherit
	EL_EQA_TEST_SET

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
			testing: "covers/{EL_IMPORTABLE_ARRAYED_LIST}.import",
				"covers/{EL_COMMA_SEPARATED_LINE_PARSER}.parse",
				"covers/{EL_COMMA_SEPARATED_VALUE_ESCAPER}.escaped",
				"covers/{EL_REFLECTIVELY_SETTABLE}.comma_separated_values"
		local
			job_list: like new_job_list
		do
			job_list := new_job_list

			do_import_test (job_list)

			do_export_test (job_list)
		end

feature {NONE} -- Implementation

	do_export_test (job_list: like new_job_list)
		local
			parser: EL_COMMA_SEPARATED_LINE_PARSER
			job, job_2: JOB
		do
			job_list.find_first_true (agent role_contains (?, "Change Manager"))
			job := job_list.item

			create parser.make
			parser.parse (job.comma_separated_names)
			log.put_line (job.comma_separated_values)
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

	new_job_list: EL_IMPORTABLE_ARRAYED_LIST [JOB]
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
