note
	description: "[$source EQA_TEST_SET] that can be invoked in finalized application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-03 9:06:19 GMT (Monday 3rd October 2022)"
	revision: "9"

deferred class
	EL_EQA_TEST_SET

inherit
	EQA_TEST_SET
		rename
			file_system as ise_file_system
		redefine
			on_prepare
		end

	EL_MODULE_FILE_SYSTEM;	EL_MODULE_OS

feature -- Basic operations

	do_all (evaluator: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		deferred
		end

feature {NONE} -- Implementation

	assert_same_string (a, b: READABLE_STRING_GENERAL)
		do
			assert ("same string", a.same_string (b))
		end

feature {NONE} -- Event handling

	on_prepare
		local
			global: EL_SINGLETON [EL_GLOBAL_LOGGING]
			logging: EL_GLOBAL_LOGGING
		do
			create global
			if not global.is_created then
				create logging.make (False)
			end
		end

end