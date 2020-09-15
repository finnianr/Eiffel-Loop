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
	date: "2020-09-15 11:01:46 GMT (Tuesday 15th September 2020)"
	revision: "4"

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
		do
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
			if test_type_list.all_conform then
				create failed_list.make_empty
				across test_type_list as type loop
					create evaluator.make (type.item)
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
			Result := type.name.same_string (Application_option.test_set)
		end

	is_logging_active: BOOLEAN
		do
			Result := True
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		local
			list: ARRAYED_LIST [like CLASS_ROUTINES]
			type_list: like test_type_list
		do
			type_list := test_type_list
			create list.make (type_list.count + 1)
			list.extend ([{like Current}, All_routines])
			across type_list as type loop
				if attached {TYPE [EL_MODULE_LOG]} type.item as logged_type then
					list.extend ([logged_type, All_routines])
				end
			end
			Result := list.to_array
		end

feature {NONE} -- Internal attributes

	test_set_name: STRING

	test_type_list: EL_TUPLE_TYPE_LIST [EL_EQA_TEST_SET]

feature {NONE} -- Constants

	Application_option: EL_AUTOTEST_COMMAND_OPTIONS
		once
			create Result.make
		end

	Description: STRING = "Call manual and automatic sets during development"

end