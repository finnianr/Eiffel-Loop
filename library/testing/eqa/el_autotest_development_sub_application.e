note
	description: "Sub application for calling a particular AutoTest test"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-14 13:24:25 GMT (Thursday 14th February 2019)"
	revision: "7"

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
		do
			across evalator_types as type loop
				if attached {EL_EQA_TEST_SET_EVALUATOR [EQA_TEST_SET]} Eiffel.new_instance_of (type.item.type_id)
					as evaluator
				then
					evaluator.default_create
					evaluator.execute
				end
				lio.put_new_line
			end
		end

feature {NONE} -- Implementation

	evalator_types: ARRAY [like Type_evaluator]
		deferred
		end

feature {NONE} -- Constants

	Type_evaluator: TYPE [EL_EQA_TEST_SET_EVALUATOR [EQA_TEST_SET]]
		require
			never_called: False
		once
		end

	Description: STRING = "Call manual and automatic sets during development"

	Option_name: STRING = "autotest"

end
