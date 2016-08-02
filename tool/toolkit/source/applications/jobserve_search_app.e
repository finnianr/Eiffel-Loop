note
	description: "Summary description for {JOBSERVE_SEARCH_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 20:03:14 GMT (Friday 8th July 2016)"
	revision: "1"

class
	JOBSERVE_SEARCH_APP

inherit
	EL_SUB_APPLICATION
		undefine
			new_lio, new_log_manager
		redefine
			option_name
		end

	EL_REGRESSION_TESTING_APPLICATION

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make

feature {NONE} -- Initiliazation

	normal_initialize
			--
		do
			Args.set_string_from_word_option (Input_path_option_name, agent set_root_node, "jobserve.xml")
			Args.set_string_from_word_option ("filter", agent set_query_filter, "")
			create duration_parser.make
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

			Test.do_file_test ("jobserve-duration-list.txt", agent test_parser, 0)
			log.exit
		end

feature -- Element change

	set_root_node (file_path: ZSTRING)
			--
		do
			create root_node.make_from_file (file_path)
		end

	set_query_filter (a_query_filter: ZSTRING)
			--
		do
			query_filter := a_query_filter
			if not query_filter.is_empty then
				query_filter.prepend_string_general (" and (")
				query_filter.append_character (')')
			end
		end

feature {NONE} -- Tests

	test_parser (file_path: EL_FILE_PATH)
			--
		local
			duration_text_list: EL_FILE_LINE_SOURCE
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

	root_node: EL_XPATH_ROOT_NODE_CONTEXT

	duration_parser: JOB_DURATION_PARSER

	query_filter: STRING

feature {NONE} -- Constants

	Option_name: STRING
			--
		do
			create Result.make_from_string ("jobserve")
		end

	Description: STRING = "Search Jobserve XML for short contracts"

--	Ask_user_to_quit: BOOLEAN is true

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{JOBSERVE_SEARCH_APP}, All_routines]
			>>
		end

end