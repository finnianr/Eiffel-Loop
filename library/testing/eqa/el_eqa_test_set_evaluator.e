note
	description: "[
		EQA test set evaluator that makes it possible to run inherited test procedures.
		
		Can be used in conjunction with class [$source EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION] to
		create unit testing sub-applications.
	]"
	descendants: "[
			EL_EQA_TEST_SET_EVALUATOR [EQA_TEST_SET]*
				[$source HTTP_CONNECTION_TEST_EVALUATOR]
				[$source SEARCH_ENGINE_TEST_EVALUATOR]
					[$source ENCRYPTED_SEARCH_ENGINE_TEST_EVALUATOR]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-21 14:54:40 GMT (Tuesday 21st January 2020)"
	revision: "8"

deferred class
	EL_EQA_TEST_SET_EVALUATOR [G -> EQA_TEST_SET create default_create end]

inherit
	EL_COMMAND
		redefine
			default_create
		end

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_MODULE_EXCEPTION

	EL_MODULE_EIFFEL

feature {EL_MODULE_EIFFEL} -- Initialization

	default_create
		do
			-- create a new instance of `item' without calling `default_create'
			-- (`default_create' is called by `evaluator')
			if attached {like item} Eiffel.new_instance_of (({like item}).type_id) as new then
				item := new
			end
			create failure_table.make_equal (3)
		end

feature -- Access

	failure_table: HASH_TABLE [EXCEPTION, STRING]

	test_set_name: STRING
		-- class name of test set
		do
			Result := ({like item}).name
		end

feature -- Status query

	has_failure: BOOLEAN
		do
			Result := not failure_table.is_empty
		end

feature -- Basic operations

	execute
		local
			evaluator: EQA_TEST_EVALUATOR [like item]
			l_result: EQA_PARTIAL_RESULT; duration: EL_DATE_TIME_DURATION
		do
			create evaluator
			print_name
			across test_table as test loop
				lio.put_labeled_string ("Executing test", test.key)
				lio.put_new_line
				l_result := evaluator.execute (agent do_test (?, test.key, test.item))
				if l_result.is_pass then
					create duration.make_from_other (l_result.duration)
					lio.put_labeled_string ("Executed in", duration.out_mins_and_secs)
					lio.put_new_line
					lio.put_line ("TEST OK")
				else
					lio.put_line ("TEST FAILED")
				end
				lio.put_new_line
			end
		end

	print_name
		do
			lio.put_labeled_string ("TEST SET", ({like item}).name)
			lio.put_new_line_x2
		end

	print_failures
		do
			print_name
			across failure_table as failed loop
				lio.put_labeled_string ("Test " + failed.key + " failed", failed.item.description)
				lio.put_new_line
				across failed.item.trace.split ('%N') as line loop
					lio.put_line (line.item)
				end
				if not failed.is_last then
					User_input.press_enter
				end
			end
		end

feature {NONE} -- Implementation

	do_test (test_set: like item; name: STRING; test: PROCEDURE)
		local
			skip: BOOLEAN
		do
			if not skip then
				test.set_target (test_set)
				test.apply
			end
		rescue
			failure_table [name] := Exception.last_exception
			skip := True
			retry
		end

	test_table: EL_PROCEDURE_TABLE [STRING]
		deferred
		end

	item: G

end
