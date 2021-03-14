note
	description: "Test [$source EVOLICITY_TEMPLATES] and related classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-14 14:27:43 GMT (Sunday 14th March 2021)"
	revision: "1"

class
	EVOLICITY_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EL_MODULE_LOG

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_EVOLICITY_TEMPLATES

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("if_then", agent test_if_then)
			eval.call ("merge_template", agent test_merge_template)
		end

feature -- Tests

	test_if_then
		do
			do_test ("merge_if_then", 1602173828, agent merge_if_then, [work_area_data_dir + "if_then.evol"])
		end

	test_merge_template
		do
			do_test ("merge_template", 1339847166, agent merge_template, [work_area_data_dir + "jobserve-results.evol"])
		end

feature {NONE} -- Implementation

	merge_if_then (template_path: EL_FILE_PATH)
			--
		local
			vars: EVOLICITY_CONTEXT_IMP
			var_x, var_y: STRING
		do
			create vars.make
			Evolicity_templates.put_file (template_path, Utf_8_encoding)
			var_x := "x"; var_y := "y"

			vars.put_integer (var_x, 2)
			vars.put_integer (var_y, 2)
			log.put_string_field_to_max_length ("RESULT", Evolicity_templates.merged_to_string (template_path, vars), 120)
			log.put_new_line

			vars.put_integer (var_x, 1)
			log.put_string_field_to_max_length ("RESULT", Evolicity_templates.merged_to_string (template_path, vars), 120)
			log.put_new_line
		end

	merge_template (template_path: EL_FILE_PATH)
			--
		local
			html_file: EL_PLAIN_TEXT_FILE; output_path: EL_FILE_PATH
		do
			Evolicity_templates.put_file (template_path, Utf_8_encoding)

			output_path := template_path.with_new_extension ("html")

			create html_file.make_open_write (output_path)
			Evolicity_templates.merge_to_file (template_path, new_root_context, html_file)
			log.put_labeled_string ("Digest", file_digest (output_path).to_hex_string)
			log.put_new_line
		end

	new_root_context: EVOLICITY_CONTEXT_IMP
			--
		local
			title_context, query_context, job_search_context: EVOLICITY_CONTEXT_IMP
			result_set_context: EVOLICITY_CONTEXT; title_var_ref: EVOLICITY_VARIABLE_REFERENCE
			result_set: LINKED_LIST [EVOLICITY_CONTEXT]
		do
			-- #set ($page.title = "Jobserve results" )
			log.enter ("new_root_context")
			create Result.make
			create title_context.make
			title_context.put_variable ("Jobserve results", "title")
			Result.put_variable (title_context, "page")

			create result_set.make

			-- First record
			result_set_context := create {JOB_INFORMATION}.make (
				"Java XML Developer", "1 year", "Write XML applications in Java with Eclipse",
				"7 March 2006", "Susan Hebridy", "JS238543", "17 March 2006", "London", 42000
			)
			create title_var_ref.make_from_array (<< "title" >>)
			log.put_string_field ("result_set_context.title", result_set_context.referenced_item (title_var_ref).out)
			log.put_new_line

			result_set.extend (result_set_context)

			-- Second record
			result_set_context := create {JOB_INFORMATION}.make (
				"Eiffel Developer", "permanent", "Write Eiffel applications using EiffelStudio",
				"7 Feb 2006", "Martin Demon", "JS238458", "27 March 2006", "Dusseldorf", 50000
			)

			result_set.extend (result_set_context)

			create job_search_context.make
			job_search_context.put_variable (result_set ,"result_set")
			create query_context.make
			query_context.put_variable (job_search_context, "job_search")
			Result.put_variable (query_context, "query")
			log.exit
		end

feature {NONE} -- Constants

	Source_dir: EL_DIR_PATH
		once
			Result := EL_test_data_dir.joined_dir_path ("evol")
		end

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_default -- UTF-8
		end
end