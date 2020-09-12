note
	description: "Evolicity test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-12 13:51:40 GMT (Saturday 12th September 2020)"
	revision: "12"

class
	EVOLICITY_TEST_APP

inherit
	TEST_SUB_APPLICATION
		rename
			extra_log_filter as no_log_filter
		end

	EL_MODULE_EVOLICITY_TEMPLATES

create
	make

feature -- Basic operations

	test_run
			--
		do
			Test.set_excluded_file_extensions (<< "evc" >>)
			Test.do_file_test ("evol/jobserve-results.evol", agent write_substituted_template, 2710416379)
			Test.do_file_test ("evol/if_then.evol", agent test_if_then, 1766908322)
		end

feature -- Test

	test_if_then (template_path: EL_FILE_PATH)
			--
		local
			vars: EVOLICITY_CONTEXT_IMP
			var_x, var_y: STRING
		do
			log.enter ("test_if_then")
			create vars.make
			Evolicity_templates.put_file (template_path, Utf_8_encoding)
			var_x := "x"; var_y := "y"

			vars.put_integer (var_x, 2)
			vars.put_integer (var_y, 2)
			log.put_string_field_to_max_length ("RESULT", Evolicity_templates.merged (template_path, vars), 120)
			log.put_new_line

			vars.put_integer (var_x, 1)
			log.put_string_field_to_max_length ("RESULT", Evolicity_templates.merged (template_path, vars), 120)
			log.exit
		end

	write_substituted_template (template_path: EL_FILE_PATH)
			--
		local
			html_file: EL_PLAIN_TEXT_FILE
		do
			log.enter ("write_substituted_template")
			create root_context.make
			Evolicity_templates.put_file (template_path, Utf_8_encoding)

			initialize_root_context
			create html_file.make_open_write (template_path.with_new_extension ("html"))
			Evolicity_templates.merge_to_file (template_path, root_context, html_file)
			log.exit
		end

feature {NONE} -- Implementation

	compile: TUPLE [EVOLICITY_TUPLE_CONTEXT]
		do
			create Result
		end

	initialize_root_context
			--
		local
			title_context, query_context, job_search_context: EVOLICITY_CONTEXT_IMP
			result_set_context: EVOLICITY_CONTEXT; title_var_ref: EVOLICITY_VARIABLE_REFERENCE
			result_set: LINKED_LIST [EVOLICITY_CONTEXT]
		do
			-- #set ($page.title = "Jobserve results" )
			log.enter ("initialize_root_context")
			create title_context.make
			title_context.put_variable ("Jobserve results", "title")
			root_context.put_variable (title_context, "page")

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
			root_context.put_variable (query_context, "query")
			log.exit
		end

feature {NONE} -- Internal attributes

	root_context: EVOLICITY_CONTEXT_IMP

feature {NONE} -- Constants

	Description: STRING = "Test Evolicity template substitution"

	Utf_8_encoding: EL_ENCODEABLE_AS_TEXT
		once
			create Result.make_default -- UTF-8
		end

end
