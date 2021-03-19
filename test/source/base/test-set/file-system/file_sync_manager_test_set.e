note
	description: "Test classes [$source EL_FTP_SYNC_BUILDER_CONTEXT] and [$source EL_FTP_SYNC]"
	notes: "[
		Unfinished test
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-19 18:00:33 GMT (Friday 19th March 2021)"
	revision: "14"

class
	FILE_SYNC_MANAGER_TEST_SET

inherit
	HELP_PAGES_TEST_SET
		undefine
			new_lio
		end

	EL_EQA_REGRESSION_TEST_SET
		undefine
			on_prepare, on_clean
		end

	EL_MODULE_TRACK

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("file_transfer", agent test_file_transfer)
		end

feature -- Tests

	test_file_transfer
		local
			manager: EL_FILE_SYNC_ITEM_SET; destination: EL_LOCAL_FILE_SYNC_MEDIUM
		do
		end

feature {NONE} -- Constants


end