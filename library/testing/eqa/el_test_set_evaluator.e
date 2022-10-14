note
	description: "[
		EQA test set evaluator that makes it possible to run inherited test procedures
		as finalized executables.

		Can be used in conjunction with class [$source EL_AUTOTEST_APPLICATION] to
		create unit testing sub-applications.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-03 12:49:01 GMT (Monday 3rd October 2022)"
	revision: "7"

class
	EL_TEST_SET_EVALUATOR

inherit
	EL_COMMAND

	EL_MODULE_LIO

	EL_MODULE_USER_INPUT

	EL_MODULE_EXCEPTION

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	make (test_set_type: like item_type; a_test_name: STRING)
		require
			valid_test_name: a_test_name.count >= 0
		do
			item_type := test_set_type; test_name := a_test_name
			-- create a new instance of `item' without calling `default_create'
			if attached {like item} Eiffel.new_instance_of (test_set_type.type_id) as new then
				item := new
			end
			if attached {like evaluator} Eiffel.new_factory_instance ({like evaluator}, test_set_type) as new then
				evaluator := new
			else
				create {EQA_TEST_EVALUATOR [EL_DEFAULT_TEST_SET]} evaluator
			end
			create failure_table.make_equal (3)
		end

feature -- Access

	failure_table: HASH_TABLE [EQA_TEST_INVOCATION_EXCEPTION, STRING]

	test_set_name: STRING
		-- class name of test set
		do
			Result := item_type.name
		end

feature -- Status query

	has_failure: BOOLEAN
		do
			Result := not failure_table.is_empty
		end

feature -- Basic operations

	call (a_test_name: STRING; a_test: PROCEDURE)
		do
			if test_name.count > 0 implies test_name ~ a_test_name then
				do_call (a_test_name, a_test)
			end
		end

	execute
		do
			print_name; item.do_all (Current)
		end

	print_failures
		do
			print_name
			across failure_table as failed loop
				lio.put_labeled_substitution (
					failed.key + " failed", "%S (%"%S%")", [failed.item.recipient_name, failed.item.tag_name]
				)
				lio.put_new_line
				across failed.item.trace.split ('%N') as line loop
					lio.put_line (line.item)
				end
				User_input.press_enter
			end
		end

	print_name
		do
			lio.put_labeled_string ("Class", test_set_name)
			lio.put_new_line_x2
		end

feature {NONE} -- Implementation

	do_call (name: STRING; a_test: PROCEDURE)
		local
			partial_result: EQA_PARTIAL_RESULT; duration: EL_TIME_DURATION
		do
			lio.put_labeled_string ("Executing test", name)
			lio.put_new_line
			partial_result := evaluator.execute (agent apply (?, a_test))
			if partial_result.is_pass then
				create duration.make_by_fine_seconds (partial_result.duration.fine_seconds_count)
				lio.put_labeled_string ("Executed in", duration.out_mins_and_secs)
				lio.put_new_line
				lio.put_line ("TEST OK")
			else
				lio.put_line ("TEST FAILED")
			end
			if attached {EQA_RESULT} partial_result as full_result then
				if attached full_result.test_response.exception as test_exception then
					failure_table [name] := test_exception
				end
				if attached full_result.teardown_response.exception as teardown_exception then
					failure_table [name + " (cleanup)"] := teardown_exception
					lio.put_line ("CLEANUP FAILED")
				end
			elseif attached partial_result as partial then
				if attached partial.setup_response.exception as setup_exception then
					failure_table [name + " (setup)"] := setup_exception
					lio.put_line ("SETUP FAILED")
				end
			end
			lio.put_new_line
		end

	apply (test_set: EQA_TEST_SET; a_test: PROCEDURE)
		do
			a_test.set_target (test_set)
			a_test.apply
		end

feature {NONE} -- Internal attributes

	evaluator: EQA_TEST_EVALUATOR [EQA_TEST_SET]

	item: EL_EQA_TEST_SET

	item_type: TYPE [EL_EQA_TEST_SET]

	test_name: STRING

end