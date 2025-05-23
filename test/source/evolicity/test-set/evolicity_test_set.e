note
	description: "Test ${EVC_TEMPLATES} and related classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-11 8:57:05 GMT (Sunday 11th May 2025)"
	revision: "31"

class
	EVOLICITY_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		undefine
			new_lio
		redefine
			on_prepare
		end

	EL_MODULE_TUPLE

	EL_CRC_32_TESTABLE

	EVC_SHARED_TEMPLATES; SHARED_DATA_DIRECTORIES

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["function_call",	  agent test_function_call],
				["if_then",			  agent test_if_then],
				["iteration_loops", agent test_iteration_loops],
				["merge_template",  agent test_merge_template]
			>>)
		end

feature -- Tests

	test_function_call
		-- EVOLICITY_TEST_SET.function_call
		note
			testing: "[
				covers/{EVC_FUNCTION_REFERENCE}.make
			]"
		-- EVOLICITY_TEST_SET.test_function_call
		local
			template, merged: STRING; name: FILE_PATH; context: EVC_CONTEXT_IMP
			z: REAL_32; x: NATURAL; y: INTEGER
		do
			template := "@test.squared ($x)"; name := Evolicity_templates.new_name (Current)
			Evolicity_templates.put_source (name, template)

			create context.make
			context.put_any ("squared", agent squared)
			x := 2
			merged := Evolicity_templates.merged_to_utf_8 (name, new_tuple_context ([x, y, z, context]))
			if merged.is_natural then
				assert ("x * x = squared (x)", squared (x) = merged.to_natural)
			else
				failed ("not natural")
			end
		end

	test_if_then
		-- EVOLICITY_TEST_SET.if_then
		note
			testing: "[
				covers/{EVC_TUPLE_CONTEXT}.make,
				covers/{EVC_COMPARISON}.evaluate,
				covers/{EVC_COMPARISON}.compare_like_string_8,
				covers/{EVC_COMPARISON}.compare_like_string_32,
				covers/{EL_INITIALIZED_ARRAYED_LIST_FACTORY}.new_result_list,
				covers/{EVC_FUNCTION_REFERENCE}.make,
				covers/{EVC_FUNCTION_REFERENCE}.new_operands,
				covers/{EVC_VARIABLE_REFERENCE}.make,
				covers/{EVC_FILE_LEXER}.value_reference,
				covers/{EVC_COMPILER}.value_reference
			]"
		local
			x: NATURAL; y, i: INTEGER; z: REAL_32; is_true: BOOLEAN_REF
			str, cat_str: STRING; dog_str: ZSTRING; pig_str: STRING_32
			context: EVC_CONTEXT_IMP; boolean_array: ARRAY [BOOLEAN]
			animal_list: ARRAY [READABLE_STRING_GENERAL]
		do
			create context.make
			create str.make_empty; cat_str := "cat"; dog_str := "dog"; pig_str := "pig"
			is_true := True
			context.put_any ("str", str)
			context.put_any ("squared", agent squared)
			context.put_any ("has_substring", agent has_substring)
			context.put_any ("is_feline", agent is_feline)
			context.put_any ("is_true", is_true)
			animal_list := << cat_str, dog_str, pig_str >>
			across animal_list as list loop
				context.put_any (list.item.to_string_8, list.item)
			end

			across 1 |..| 2 as n loop
				inspect n.item
					when 1 then
						x := 2; y := 2; z := 2.2
					else
						x := 1; y := 2; z := 2; str.append (cat_str)
				end

				if attached new_merged_context_lines (If_then_evol, new_tuple_context ([x, y, z, context])) as lines
					and then attached to_boolean_array (lines) as lines_array
				then
				-- equivalent to contents of `If_then_manifest'
					boolean_array := <<
						not (x = 1) and y = 2,
						x = 1,
						x /= 1,
						y = z,
						squared (x) = 4,
						str.is_empty,
						str.count > 0,
						str ~ cat_str,
						dog_str.same_string_general (cat_str),
						dog_str > cat_str,
						cat_str < dog_str,
						pig_str > dog_str and pig_str > cat_str,
						is_true.item,
						is_feline (cat_str).item,
						is_feline (dog_str).item,
						has_substring (cat_str, "at"),
						has_substring (dog_str, "at")
					>>
					assert ("same number of tests", lines_array.count = boolean_array.count)
					if attached If_then_manifest.split ('%N') as line then
						across lines_array as array loop
							i := array.cursor_index
							assert (line [i], array.item = boolean_array [i])
						end
					end
				end
			end
		end

	test_iteration_loops
		-- EVOLICITY_TEST_SET.iteration_loops
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
		-- EVOLICITY_TEST_SET.merge_template
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

feature {NONE} -- Events

	on_prepare
		do
			Precursor
		-- Generate "evol/if_then.evol" template file
			if attached open (work_area_data_dir + If_then_evol, Write) as template then
				across If_then_manifest.split ('%N') as line loop
					template.put_line (line.item)
					template.put_lines (True_else_false.split ('%N'))
					template.put_new_line
				end
				template.close
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
			Result := Data_dir.evol
		end

	to_boolean_array (lines: EL_ZSTRING_LIST): ARRAY [BOOLEAN]
		do
			if attached {EL_ARRAYED_LIST [BOOLEAN]} lines.derived_list (agent {ZSTRING}.to_boolean) as list  then
				Result := list.to_array
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Evolicity functions

	has_substring (a, b: STRING): BOOLEAN_REF
		do
			Result := a.has_substring (b).to_reference
		end

	is_feline (animal: STRING): BOOLEAN_REF
		do
			Result := (animal ~ "cat").to_reference
		end

	squared (x: NATURAL): NATURAL
		do
			Result := x * x
		end

feature {NONE} -- Constants

	If_then_evol: STRING = "if_then.evol"

	If_then_manifest: STRING = "[
		#if not ($x = 1) and $y = 2 then
		#if $x = 1 then
		#if $x /= 1 then
		#if $y = $z then
		#if @test.squared ($x) = 4 then
		#if $test.str.is_empty then
		#if $test.str.count > 0 then
		#if $test.str = "cat" then
		#if $test.dog = "cat" then
		#if $test.dog > $test.cat then
		#if $test.cat < $test.dog then
		#if $test.pig > $test.dog and $test.pig > $test.cat then
		#if $test.is_true then
		#if @test.is_feline ($test.cat) then
		#if @test.is_feline ($test.dog) then
		#if @test.has_substring ($test.cat, "at") then
		#if @test.has_substring ($test.dog, "at") then
	]"

	Integer: EL_FORMAT_INTEGER
		once
			create Result.make_width (1)
		end

	True_else_false: STRING = "[
		True
		#else
		False
		#end
	]"

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_default -- UTF-8
		end
end