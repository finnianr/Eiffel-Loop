note
	description: "[
		Sub application allowing execution of multiple EQA unit tests. A summary of any failed tests is
		printed when all tests have finished executing.

		See any of the [$source AUTOTEST_DEVELOPMENT_APP] classes for an example.
	]"
	notes: "[
		Add command option `-single' to only test `test_type' with single test.
		
		Logging is active by default
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-05 9:35:02 GMT (Sunday 5th September 2021)"
	revision: "11"

deferred class
	EL_AUTOTEST_SUB_APPLICATION [EQA_TYPES -> TUPLE create default_create end]

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Application_option, is_logging_active, init_console_and_logging
		end

	EL_MODULE_EIFFEL

	EL_MODULE_ARGS

feature {NONE} -- Initialization

	initialize
		do
		ensure then
			all_conform_to_EL_EQA_TEST_SET: test_type_list.all_conform
		end

	init_console_and_logging
		local
			s: EL_STRING_8_ROUTINES
		do
			create test_name.make_empty
			test_set_name := s.substring_to (Application_option.test_set, '.', test_name)
			if test_name.starts_with (Test_prefix) then
				test_name.remove_head (Test_prefix.count)
			end
			create test_type_list.make_from_tuple (create {EQA_TYPES})
			if Application_option.test_set.count > 0 then
				create test_type_list.make_from_array (test_type_list.query_if (agent test_set_matches).to_array)
			end
			Precursor
		end

feature -- Basic operations

	run
		local
			failed_list: EL_ARRAYED_LIST [EL_EQA_TEST_EVALUATOR]
			evaluator: EL_EQA_TEST_EVALUATOR
		do
			if test_type_list.is_empty and then Application_option.test_set.count > 0 then
				lio.put_labeled_string ("No such test set", Application_option.test_set)
				lio.put_new_line

			elseif test_type_list.all_conform then
				create failed_list.make_empty
				across test_type_list as type loop
					create evaluator.make (type.item, test_name)
					evaluator.execute
					if evaluator.has_failure then
						failed_list.extend (evaluator)
					end
					lio.put_new_line
				end
				if failed_list.is_empty then
					lio.put_line ("All tests PASSED OK")
				else
					lio.put_line ("The following tests failed")
					lio.put_new_line
					across failed_list as failed loop
						failed.item.print_failures
					end
					exit_code := 1
				end
			else
				across test_type_list.non_conforming_list as type loop
					lio.put_labeled_string (type.item.name, "type does not conform to EL_EQA_TEST_EVALUATOR")
				end
			end
		end

feature {NONE} -- Implementation

	test_set_matches (type: TYPE [EL_EQA_TEST_SET]): BOOLEAN
		do
			Result := type.name.same_string (test_set_name)
		end

	is_logging_active: BOOLEAN
		do
			Result := True
		end

	log_filter_set: EL_LOG_FILTER_SET [TUPLE]
			--
		local
			type_list: like test_type_list
		do
			type_list := test_type_list
			create Result.make_with_count (type_list.count + 1)
			Result.show_all ({like Current})
			across type_list as list loop
				if attached {TYPE [EL_MODULE_LOG]} list.item as log_type then
					Result.show_all (log_type)
				end
			end
		end

feature {NONE} -- Internal attributes

	test_set_name: STRING

	test_name: STRING

	test_type_list: EL_TUPLE_TYPE_LIST [EL_EQA_TEST_SET]

feature {NONE} -- Constants

	Application_option: EL_AUTOTEST_COMMAND_OPTIONS
		once
			create Result.make
		end

	Description: STRING
		once
			Result := "Call manual and automatic sets during development"
		end

	Test_prefix: STRING = "test_"

end