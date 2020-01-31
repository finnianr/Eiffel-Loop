note
	description: "Regression test set using CRC32 checksum algorithm on logged output"
	notes: "[
		The type of  must be set to [$source EL_TESTING_CONSOLE_ONLY_LOG] with the sub-application
		[$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 13:30:21 GMT (Friday 31st January 2020)"
	revision: "1"

class
	EL_EQA_REGRESSION_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_SHARED_TEST_CRC

feature {NONE} -- Implementation

	do_test (name: STRING; target: NATURAL test: PROCEDURE; operands: TUPLE)
		require
			valid_lio: attached {EL_TESTING_CONSOLE_ONLY_LOG} lio
			valid_log_manager: attached {EL_TESTING_LOG_MANAGER} Log_manager
		local
			actual: NATURAL
		do
			Test_crc.reset
			if operands.is_empty then
				log.enter (name)
			else
				log.enter_with_args (name, operands)
			end
			test.call (operands)
			log.exit

			actual := Test_crc.checksum
			if target /= actual then
				log.put_natural_field ("Target checksum", target)
				log.put_natural_field (" Actual checksum", actual)
				log.put_new_line
				assert ("checksums agree", False)
			end
		end


end
