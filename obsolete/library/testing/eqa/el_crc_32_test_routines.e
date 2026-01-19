note
	description: "[
		Routines for use with [$source EL_EQA_TEST_SET] to do regression testing based on CRC-32 checksum
		of logged/console output. See **do_test* routine.
	]"
	notes: "[
		The type of `log' must be set to [$source EL_CRC_32_CONSOLE_ONLY_LOG] by running the test
		from a sub-application conforming to [$source EL_CRC_32_AUTOTEST_APPLICATION]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "14"

deferred class
	EL_CRC_32_TEST_ROUTINES

inherit
	EL_MODULE_FILE

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_SHARED_TEST_CRC

	EL_SHARED_DIGESTS

feature {NONE} -- Implementation

	assert (a_tag: STRING; a_condition: BOOLEAN)
		deferred
		end

	do_test (name: STRING; target: NATURAL test: PROCEDURE; operands: TUPLE)
		require
			valid_lio: attached {EL_CRC_32_CONSOLE_AND_FILE_LOG} lio
			valid_log_manager: attached {EL_CRC_32_LOG_MANAGER} Log_manager
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

	os_checksum (unix, windows: NATURAL): NATURAL
		do
			if {PLATFORM}.is_unix then
				Result := unix
			else
				Result := windows
			end
		end

	plain_text_digest (file_path: FILE_PATH): EL_DIGEST_ARRAY
		do
			create Result.make_from_plain_text (MD5_128, file_path)
		end

	raw_file_digest (file_path: FILE_PATH): EL_DIGEST_ARRAY
		do
			create Result.make_from_memory (MD5_128, File.data (file_path))
		end

end
