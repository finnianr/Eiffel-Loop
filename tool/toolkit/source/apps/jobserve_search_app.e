note
	description: "Jobserve search app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-20 17:29:15 GMT (Thursday 20th February 2020)"
	revision: "9"

class
	JOBSERVE_SEARCH_APP

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		rename
			extra_log_filter as no_log_filter
		redefine
			option_name, read_command_options
		end

	EL_COMMAND_ARGUMENT_CONSTANTS

	EL_MODULE_ARGS

create
	make

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			create duration_parser.make
		end

	read_command_options
		do
			Args.set_string_from_word_option (Input_path_option_name, agent set_root_node, "jobserve.xml")
			Args.set_string_from_word_option ("filter", agent set_query_filter, "")
		end

feature -- Basic operations

	normal_run
			--
		local
			jobs_result_set: JOBS_RESULT_SET
			xpath: STRING
		do
			log.enter ("run")
			create xpath.make_from_string ("/job-serve/row[type/@value='Contract'$FILTER]")
			xpath.replace_substring_all ("$FILTER", query_filter)
			log.put_string_field ("XPATH", xpath)
			log.put_new_line
			create jobs_result_set.make (root_node, xpath)
			jobs_result_set.save_as_xml ("Jobserve.results.html")

			log.exit
		end

	test_run
			--
		do
			log.enter ("test_run")
			create duration_parser.make

			Test.do_file_test ("XML/jobserve.xml", agent test_parser, 0)
			log.exit
		end

feature -- Element change

	set_query_filter (a_query_filter: ZSTRING)
			--
		do
			query_filter := a_query_filter
			if not query_filter.is_empty then
				query_filter.prepend_string_general (" and (")
				query_filter.append_character (')')
			end
		end

	set_root_node (file_path: ZSTRING)
			--
		do
			create root_node.make_from_file (file_path)
		end

feature {NONE} -- Tests

	test_parser (file_path: EL_FILE_PATH)
			--
		local
			duration_text_list: EL_PLAIN_TEXT_LINE_SOURCE
			end_index: INTEGER
		do
			log.enter ("test_parser")
			create duration_text_list.make (file_path)
			from duration_text_list.start until duration_text_list.after loop
				end_index := duration_text_list.item.substring_index_general ("(occurrences:", 1) - 2
				duration_parser.set_duration_interval (duration_text_list.item.substring (1, end_index))

				log.put_integer_interval_field ("Range", duration_parser.duration_interval)
				log.put_string (" ")
				log.put_string (duration_text_list.item)
				log.put_new_line

				duration_text_list.forth
			end
			log.exit
		end

feature {NONE} -- Implementation: attributes

	duration_parser: JOB_DURATION_PARSER

	query_filter: STRING

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

feature {NONE} -- Constants

	Description: STRING = "Search Jobserve XML for short contracts"

--	Ask_user_to_quit: BOOLEAN is true

	Option_name: STRING = "jobserve"

end
