note
	description: "[
		[$source EL_EQA_TEST_SET] that uses read-only file data in a designated working
		directory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 7:27:41 GMT (Thursday 7th September 2023)"
	revision: "1"

deferred class
	EL_DIRECTORY_CONTEXT_TEST_SET

inherit
	EL_EQA_TEST_SET
		export
			{EL_APPLICATION} clean
		redefine
			on_prepare, on_clean
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Events

	on_clean
		do
			Execution_environment.pop_current_working
			Precursor
		end

	on_prepare
		do
			Precursor
			Execution_environment.push_current_working (working_dir)
		end

feature {NONE} -- Implementation

	working_dir: DIR_PATH
		deferred
		end
end