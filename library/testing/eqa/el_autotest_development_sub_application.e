note
	description: "Sub application for calling a particular AutoTest test"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-20 13:34:35 GMT (Wednesday 20th February 2019)"
	revision: "10"

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

	evaluator_type_list (type_tuple: like evaluator_types): ARRAYED_LIST [TYPE [EL_EQA_TEST_SET_EVALUATOR [EQA_TEST_SET]]]
		local
			type_array: EL_TUPLE_TYPE_ARRAY
		do
			create type_array.make_from_tuple (type_tuple)
			create Result.make (type_array.count)
			across type_array as type loop
				if attached {like evaluator_type_list.item} type.item as evaluator_type then
					Result.extend (evaluator_type)
				end
			end
		end

feature {NONE} -- Constants

	Description: STRING = "Call manual and automatic sets during development"

	Option_name: STRING = "autotest"

end
