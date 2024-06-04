note
	description: "[
		${EL_EQA_TEST_SET} that uses read-only file data in a designated working directory.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-04 15:46:38 GMT (Tuesday 4th June 2024)"
	revision: "3"

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