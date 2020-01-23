note
	description: "[
		EQA test set evaluator that makes it possible to run inherited test procedures.
		
		Can be used in conjunction with class [$source EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION] to
		create unit testing sub-applications.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:59:44 GMT (Thursday 23rd January 2020)"
	revision: "10"

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
			-- (`default_create' is called by `evaluator' so do not call `create item')
			if attached {like item} Eiffel.new_instance_of (item_type.type_id) as new then
				item := new
			end
			create evaluator
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

	execute
		do
			print_name; do_tests
		end

	test (name: STRING; a_test: PROCEDURE)
		local
			test_result: EQA_PARTIAL_RESULT; duration: EL_DATE_TIME_DURATION
		do
			lio.put_labeled_string ("Executing test", name)
			lio.put_new_line
			test_result := evaluator.execute (agent apply (?, a_test))
			if test_result.is_pass then
				create duration.make_from_other (test_result.duration)
				lio.put_labeled_string ("Executed in", duration.out_mins_and_secs)
				lio.put_new_line
				lio.put_line ("TEST OK")
			else
				lio.put_line ("TEST FAILED")
				if attached {EQA_RESULT} test_result as l_result
					and then attached {EQA_TEST_INVOCATION_EXCEPTION} l_result.test_response.exception as test_exception
				then
					failure_table [name] := test_exception
				end
			end
			lio.put_new_line
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
			lio.put_labeled_string ("TEST SET", test_set_name)
			lio.put_new_line_x2
		end

feature {NONE} -- Implementation

	apply (test_set: like item; a_test: PROCEDURE)
		do
			a_test.set_target (test_set)
			a_test.apply
		end

	item_type: TYPE [G]
		do
			Result := {like item}
		end

	do_tests
		deferred
		end

feature {NONE} -- Internal attributes

	evaluator: EQA_TEST_EVALUATOR [like item]

	item: G;

note
	descendants: "[
			EL_EQA_TEST_SET_EVALUATOR*
				[$source AMAZON_INSTANT_ACCESS_TEST_EVALUATOR]
				[$source DATE_TEXT_TEST_EVALUATOR]
				[$source FILE_AND_DIRECTORY_TEST_EVALUATOR]
				[$source TEMPLATE_TEST_EVALUATOR]
				[$source ZSTRING_TEST_EVALUATOR]
				[$source EROS_TEST_EVALUATOR]
				[$source HTTP_CONNECTION_TEST_EVALUATOR]
				[$source ID3_TAG_INFO_TEST_EVALUATOR]
				[$source EL_SUBJECT_LINE_DECODER_TEST_EVALUATOR]
				[$source PAYPAL_TEST_EVALUATOR]
				[$source SEARCH_ENGINE_TEST_EVALUATOR]
					[$source ENCRYPTED_SEARCH_ENGINE_TEST_EVALUATOR]
				[$source TAGLIB_TEST_EVALUATOR]
				[$source REFLECTIVE_BUILDABLE_AND_STORABLE_TEST_EVALUATOR]
	]"


end
