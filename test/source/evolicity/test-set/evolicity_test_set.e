note
	description: "Test ${EVOLICITY_TEMPLATES} and related classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 13:30:13 GMT (Monday 23rd September 2024)"
	revision: "21"

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
				["if_then", agent test_if_then],
				["iteration_loops", agent test_iteration_loops],
				["merge_template", agent test_merge_template]
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
		local
			title_var_ref: EVOLICITY_VARIABLE_REFERENCE
		do
			if attached new_job_list as job_list then
				create title_var_ref.make_from_array (<< "title" >>)
				assert ("same string", job_list [1].referenced_item (title_var_ref).out ~ "Java XML Developer")
				assert ("same string", job_list [2].referenced_item (title_var_ref).out ~ "Eiffel Developer")

				do_test ("merge_template", 1591458457, agent merge_template, ["jobserve-results.evol", new_job_info (job_list)])
			end
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

	new_tuple_context (x, y: INTEGER; str: STRING): EVOLICITY_TUPLE_CONTEXT
		do
			create Result.make ([x, y, str], "x, y, str")
		end

	new_job_info (job_list: like new_job_list): EVOLICITY_CONTEXT_IMP
			--
		local
			title_context, query_context, job_search_context: EVOLICITY_CONTEXT_IMP
			result_set_context: EVOLICITY_CONTEXT;
		do
			-- #set ($page.title = "Jobserve results" )
			create Result.make
			create title_context.make
			title_context.put_any ("title", "Jobserve results")
			Result.put_any ("page", title_context)

			create job_search_context.make
			job_search_context.put_any ("result_set", job_list)
			create query_context.make
			query_context.put_any ("job_search", job_search_context)
			Result.put_any ("query", query_context)
		end

	new_job_list: ARRAYED_LIST [JOB_INFORMATION]
		do
			create Result.make_from_array (<<
				create {JOB_INFORMATION}.make (
					"Java XML Developer", "1 year", "Write XML applications in Java with Eclipse",
					"7 March 2006", "Susan Hebridy", "JS238543", "17 March 2006", "London", 42000
				),
				create {JOB_INFORMATION}.make (
					"Eiffel Developer", "permanent", "Write Eiffel applications using EiffelStudio",
					"7 Feb 2006", "Martin Demon", "JS238458", "27 March 2006", "Dusseldorf", 50000
				)
			>>)
		end

feature {NONE} -- Constants

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_default -- UTF-8
		end
end