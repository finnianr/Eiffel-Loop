note
	description: "Sub application for calling a particular AutoTest test"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-23 11:52:23 GMT (Saturday 23rd February 2019)"
	revision: "12"

deferred class
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_MODULE_EIFFEL

feature {NONE} -- Initialization

	initialize
		do

		end

feature -- Basic operations

	run
		local
			failed_list: EL_ARRAYED_LIST [EL_EQA_TEST_SET_EVALUATOR [EQA_TEST_SET]]
		do
			create failed_list.make_empty
			across evaluator_type_list (evaluator_types) as type loop
				if attached {EL_EQA_TEST_SET_EVALUATOR [EQA_TEST_SET]} Eiffel.new_instance_of (type.item.type_id)
					as evaluator
				then
					lio.put_labeled_string ("Creating", evaluator.test_set_name)
					lio.put_new_line
					evaluator.default_create
					evaluator.execute
					if evaluator.has_failure then
						failed_list.extend (evaluator)
					end
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

	evaluator_types: TUPLE
		deferred
		ensure
			correct_types: evaluator_type_list (Result).count = Result.count
		end

	evaluator_type_list (type_tuple: like evaluator_types): EL_TUPLE_TYPE_LIST [EL_EQA_TEST_SET_EVALUATOR [EQA_TEST_SET]]
		do
			create Result.make_from_tuple (type_tuple)
		end

feature {NONE} -- Constants

	Description: STRING = "Call manual and automatic sets during development"

	Option_name: STRING = "autotest"

end
