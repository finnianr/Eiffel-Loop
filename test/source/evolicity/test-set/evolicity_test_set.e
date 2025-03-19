note
	description: "Test ${EVC_TEMPLATES} and related classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-19 18:44:06 GMT (Wednesday 19th March 2025)"
	revision: "26"

class
	EVOLICITY_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_TUPLE

	EVC_SHARED_TEMPLATES

	SHARED_DEV_ENVIRON

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
		note
			testing: "[
				covers/{EVC_TUPLE_CONTEXT}.make,
				covers/{EVC_COMPARISON}.evaluate,
				covers/{EL_INITIALIZED_ARRAYED_LIST_FACTORY}.new_result_list
			]"
		local
			x: NATURAL; y: INTEGER; z: REAL_32; str, abc_str: STRING; boolean_array: ARRAY [BOOLEAN]
			context: EVC_CONTEXT_IMP
		do
			create context.make
			create str.make_empty; abc_str := "abc"
			context.put_any ("str", str)

			across 1 |..| 2 as n loop
				inspect n.item
					when 1 then
						x := 2; y := 2
					else
						x := 1; y := 2; str.append (abc_str)
				end

				if attached new_merged_context_lines ("if_then.evol", new_tuple_context ([x, y, z, context])) as lines
					and then attached to_boolean_array (lines) as lines_array
				then
					boolean_array := <<
						not (x = 1) and y = 2,
						x = 1,
						x /= 1,
						str.is_empty,
						str.count > 0,
						str ~ abc_str
					>>
					assert ("same results", lines_array ~ boolean_array)
				end
			end
		end

	test_iteration_loops
		local
			check_sum_table: EL_HASH_TABLE [STRING, NATURAL]
		do
			create check_sum_table.make_assignments (<<
				[checksum (3638825393), "foreach.evol"], [checksum (2516937336), "across.evol"]
			>>)
			across check_sum_table as table loop
				do_test ("display_merged", table.key, agent display_merged, [table.item, new_container_context])
			end
		end

	test_merge_template
		-- EVOLICITY_TEST_SET.test_merge_template
		note
			testing: "[
				covers/{EVC_FUNCTION_REFERENCE}.make,
				covers/{EVC_FUNCTION_REFERENCE}.new_operands,
				covers/{EVC_VARIABLE_REFERENCE}.make,
				covers/{EVC_FILE_LEXER}.value_reference,
				covers/{EVC_COMPILER}.value_reference,
				covers/{EVC_FUNCTION_TABLE}.found_item_result
			]"
		local
			title_var_ref: EVC_VARIABLE_REFERENCE
		do
			if attached new_job_list as job_list then
				create title_var_ref.make_from_array (<< "title" >>)
				assert ("same string", job_list [1].referenced_item (title_var_ref).out ~ "Java XML Developer")
				assert ("same string", job_list [2].referenced_item (title_var_ref).out ~ "Eiffel Developer")

				do_test ("merge_template", 1595448774, agent merge_template, ["jobserve-results.evol", new_job_info (job_list)])
			end
		end

feature {NONE} -- Factory

	new_container_context: EVC_CONTEXT_IMP
		local
			table: EL_HASH_TABLE [INTEGER, STRING]
			integer_list: EL_ARRAYED_LIST [INTEGER]
		do
			create Result.make
			create integer_list.make_from (1 |..| 3)
			create table.make_equal (3)
			across integer_list as list loop
				table.extend (list.item, Integer.spell (list.item))
			end

			Result.put_any ("value_table", table)
			Result.put_any ("string_list", table.key_list)
			Result.put_any ("integer_list", integer_list)
			Result.put_any ("spell", agent Integer.spell)
		end

	new_context: EVC_CONTEXT_IMP
		do
			create Result.make
		end

	new_date (y, m, d: INTEGER): EL_DATE
		do
			create Result.make (y, m, d)
		end

	new_job_info (job_list: like new_job_list): EVC_CONTEXT_IMP
			--
		do
			create Result.make
			Result.put_any ("formatted", agent formatted_date)

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

	new_merged_context_lines (name: STRING; context: EVC_CONTEXT_IMP): EL_ZSTRING_LIST
			--
		do
			if attached (work_area_data_dir + name) as template_path then
				Evolicity_templates.put_file (template_path, Utf_8_encoding)
				Result := Evolicity_templates.merged_to_string (template_path, context).lines
				Result.prune_all_empty
			end
		end

	new_tuple_context (a_tuple: TUPLE [x: NATURAL; y: INTEGER; z: REAL_32; context: EVC_CONTEXT_IMP]): EVC_TUPLE_CONTEXT
		do
			create Result.make (a_tuple, "x, y, z, test")
		end

feature {NONE} -- Implementation

	display_merged (name: STRING; context: EVC_CONTEXT_IMP)
			--
		do
			lio.put_labeled_lines ("RESULT", new_merged_context_lines (name, context))
		end

	formatted_date (date: EL_DATE; format: STRING): STRING
		do
			Result := date.formatted_out (format)
		end

	merge_template (name: STRING; job_info: EVC_CONTEXT_IMP)
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

	to_boolean_array (lines: EL_ZSTRING_LIST): ARRAY [BOOLEAN]
		do
			if attached {EL_ARRAYED_LIST [BOOLEAN]} lines.derived_list (agent {ZSTRING}.to_boolean) as list  then
				Result := list.to_array
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Constants

	Integer: EL_FORMAT_INTEGER
		once
			create Result.make_width (1)
		end

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_default -- UTF-8
		end
end