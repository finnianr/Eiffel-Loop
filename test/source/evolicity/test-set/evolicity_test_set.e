note
	description: "Test ${EVOLICITY_TEMPLATES} and related classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-14 8:00:06 GMT (Friday 14th March 2025)"
	revision: "23"

class
	EVOLICITY_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_TUPLE

	SHARED_DEV_ENVIRON

	EVOLICITY_SHARED_TEMPLATES

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["if_then",			  agent test_if_then],
				["iteration_loops", agent test_iteration_loops],
				["merge_template",  agent test_merge_template]
			>>)
		end

feature -- Tests

	test_if_then
		do
			do_test ("merge_context", 2851934917, agent merge_context, ["if_then.evol", new_tuple_context (2, 2, "")])
			do_test ("merge_context", 1728344681, agent merge_context, ["if_then.evol", new_tuple_context (1, 2, "abc")])
		end

	test_iteration_loops
		do
			do_test ("merge_context", 3227915363, agent merge_context, ["foreach.evol", new_container_context])
			do_test ("merge_context", 1196563676, agent merge_context, ["across.evol", new_container_context])
		end

	test_merge_template
		-- EVOLICITY_TEST_SET.test_merge_template
		note
			testing: "[
				covers/{EVOLICITY_FUNCTION_REFERENCE}.make,
				covers/{EVOLICITY_FUNCTION_REFERENCE}.new_operands,
				covers/{EVOLICITY_VARIABLE_REFERENCE}.make,
				covers/{EVOLICITY_FILE_LEXER}.variable_reference,
				covers/{EVOLICITY_COMPILER}.variable_reference,
				covers/{EVOLICITY_FUNCTION_TABLE}.found_item_result
			]"
		local
			title_var_ref: EVOLICITY_VARIABLE_REFERENCE
		do
			if attached new_job_list as job_list then
				create title_var_ref.make_from_array (<< "title" >>)
				assert ("same string", job_list [1].referenced_item (title_var_ref).out ~ "Java XML Developer")
				assert ("same string", job_list [2].referenced_item (title_var_ref).out ~ "Eiffel Developer")

				do_test ("merge_template", 1159669919, agent merge_template, ["jobserve-results.evol", new_job_info (job_list)])
			end
		end

feature {NONE} -- Factory

	new_container_context: EVOLICITY_CONTEXT_IMP
		local
			table: EL_HASH_TABLE [INTEGER, STRING]
		do
			create Result.make
			table := << ["one", 1], ["two", 2], ["three", 3] >>
			Result.put_any ("value_table", table)
			Result.put_any ("string_list", table.key_list)
		end

	new_context: EVOLICITY_CONTEXT_IMP
		do
			create Result.make
		end

	new_job_info (job_list: like new_job_list): EVOLICITY_CONTEXT_IMP
			--
		do
			create Result.make
			if attached new_context as title then
				title.put_string ("title", "Jobserve results")
				Result.put_any ("page", title)
			end
			if attached new_context as result_set then
				result_set.put_any ("result_set", job_list)
				if attached new_context as job_search then
					job_search.put_any ("job_search", result_set)
					Result.put_any ("query", job_search)
				end
			end
		end

	new_job_list: ARRAYED_LIST [JOB_INFORMATION]
		do
			create Result.make_from_array (<<
				create {JOB_INFORMATION}.make (
					"Java XML Developer", "1 year", "Write XML applications in Java with Eclipse",
					"Susan Hebridy", "JS238543", "London",
					new_date (2006, 3, 7), new_date (2006, 3, 17), 42000
				),
				create {JOB_INFORMATION}.make (
					"Eiffel Developer", "permanent", "Write Eiffel applications using EiffelStudio",
					"Martin Demon", "JS238458", "Dusseldorf",
					new_date (2006, 2, 7), new_date (2006, 3, 27), 50000
				)
			>>)
		end

	new_tuple_context (x, y: INTEGER; str: STRING): EVOLICITY_TUPLE_CONTEXT
		do
			create Result.make ([x, y, str], "x, y, str")
		end

	new_date (y, m, d: INTEGER): EL_DATE
		do
			create Result.make (y, m, d)
		end

feature {NONE} -- Implementation

	merge_context (name: STRING; context: EVOLICITY_CONTEXT_IMP)
			--
		do
			if attached (work_area_data_dir + name) as template_path then
				Evolicity_templates.put_file (template_path, Utf_8_encoding)

				lio.put_curtailed_string_field ("RESULT", Evolicity_templates.merged_to_string (template_path, context), 160)
				lio.put_new_line
			end
		end

	merge_template (name: STRING; job_info: EVOLICITY_CONTEXT_IMP)
			--
		local
			html_file: EL_PLAIN_TEXT_FILE; line_source: EL_PLAIN_TEXT_LINE_SOURCE
		do
			if attached (work_area_data_dir + name) as template_path then
				Evolicity_templates.put_file (template_path, Utf_8_encoding)

				if attached template_path.with_new_extension ("html") as output_path then
					create html_file.make_open_write (output_path)
					Evolicity_templates.merge_to_file (template_path, job_info, html_file)
					create line_source.make_utf_8 (output_path)
					across line_source as line loop
						lio.put_line (line.shared_item)
					end
				end
			end
		end

	source_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir #+ "evol"
		end

feature {NONE} -- Constants

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_default -- UTF-8
		end
end