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
	date: "2020-08-24 10:43:39 GMT (Monday 24th August 2020)"
	revision: "3"

deferred class
	EL_AUTOTEST_SUB_APPLICATION

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Application_option, is_logging_active
		end

	EL_MODULE_EIFFEL

	EL_MODULE_ARGS

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	run
		local
			failed_list: EL_ARRAYED_LIST [EL_EQA_TEST_EVALUATOR]
			evaluator: EL_EQA_TEST_EVALUATOR
		do
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
		end

feature {NONE} -- Implementation

	test_type: TUPLE
		-- single type for evaluation (word option -single)
		deferred
		end

	test_types_all: TUPLE
		deferred
		end

	test_type_list: EL_TUPLE_TYPE_LIST [EL_EQA_TEST_SET]
		do
			if Application_option.single then
				create Result.make_from_tuple (test_type)
			else
				create Result.make_from_tuple (test_types_all)
			end
		ensure
			all_conform_to_EL_EQA_TEST_SET: test_type_list.all_conform
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

	is_logging_active: BOOLEAN
		do
			Result := True
		end

feature {NONE} -- Constants

	Application_option: EL_AUTOTEST_COMMAND_OPTIONS
		once
			create Result.make
		end

	Description: STRING = "Call manual and automatic sets during development"

end
