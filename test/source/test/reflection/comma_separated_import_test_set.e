note
	description: "Summary description for {COMMA_SEPARATED_IMPORT_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-14 17:34:16 GMT (Thursday 14th December 2017)"
	revision: "1"

class
	COMMA_SEPARATED_IMPORT_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_LOG
		undefine
			default_create
		end

feature -- Test

	test_csv_parse
			--
		local
			job_list: EL_IMPORTABLE_ARRAYED_LIST [JOB]
		do
			log.enter ("test_csv_parse")
			create job_list.make (10)
			job_list.import_csv_latin_1 ("data/JobServe.csv")
			assert ("Type is Contract x 2", job_list.count_of (agent is_type (?, "Contract")) = 2)
			assert ("Role contains Manager x 2", job_list.count_of (agent role_contains (?, "Manager")) = 2)
			assert ("telephone_1 is  x 3", job_list.count_of (agent telephone_1_starts (?, "0208")) = 3)
			log.exit
		end

feature {NONE} -- Implementation

	is_type (job: JOB; name: STRING): BOOLEAN
		do
			Result := job.type ~ name
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
