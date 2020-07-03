note
	description: "Regression test set using CRC32 checksum algorithm on logged output"
	notes: "[
		The type of `log' must be set to [$source EL_TESTING_CONSOLE_ONLY_LOG] by running the test
		from a sub-application conforming to [$source EL_REGRESSION_AUTOTEST_SUB_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-01 10:30:26 GMT (Wednesday 1st July 2020)"
	revision: "6"

deferred class
	EL_EQA_REGRESSION_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_SHARED_TEST_CRC

	EL_SHARED_DIGESTS

feature {NONE} -- Implementation

	do_test (name: STRING; target: NATURAL test: PROCEDURE; operands: TUPLE)
		require
			valid_lio: attached {EL_TESTING_CONSOLE_AND_FILE_LOG} lio
			valid_log_manager: attached {EL_TESTING_LOG_MANAGER} Log_manager
			valid_operands: test.valid_operands (operands)
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

	file_digest (file_path: EL_FILE_PATH): EL_DIGEST_ARRAY
		do
			create Result.make_from_memory (MD5_128, File_system.file_data (file_path))
		end

	os_checksum (unix, windows: NATURAL): NATURAL
		do
			if {PLATFORM}.is_unix then
				Result := unix
			else
				Result := windows
			end
		end

end
