note
	description: "[
		Routines for use with ${EL_EQA_TEST_SET} to do regression testing based on CRC-32 checksum
		of logged/console output. See **do_test** routine.
	]"
	notes: "[
		The type of `log' must be set to ${EL_CRC_32_CONSOLE_ONLY_LOG} by running the test
		from a sub-application conforming to ${EL_CRC_32_AUTOTEST_APPLICATION}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-19 7:00:57 GMT (Wednesday 19th March 2025)"
	revision: "19"

deferred class
	EL_CRC_32_TESTABLE

inherit
	EL_MODULE_FILE

	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_SHARED_TEST_CRC

feature {NONE} -- Implementation

	checksum (n: NATURAL): NATURAL
		do
			Result := n
		end

	assert (a_tag: READABLE_STRING_GENERAL; a_condition: BOOLEAN)
		deferred
		end

	do_test (name: STRING; target_checksum: NATURAL test: PROCEDURE; operands: TUPLE)
		require
			valid_lio: attached {EL_CRC_32_CONSOLE_AND_FILE_LOG} lio
			valid_log_manager: attached {EL_CRC_32_LOG_MANAGER} Log_manager
			valid_operands: test.valid_operands (operands)
		local
			actual_checksum: NATURAL
		do
			Test_crc.reset
			if operands.is_empty then
				log.enter (name)
			else
				log.enter_with_args (name, operands)
			end
			test.call (operands)
			log.exit

			actual_checksum := Test_crc.checksum
			log.put_new_line

			if target_checksum /= actual_checksum then
				log.put_natural_field ("Expected checksum", target_checksum)
				log.put_natural_field (" actual checksum", actual_checksum)
				log.put_new_line
				assert ("Routine %"" + name + "%" checksums agree", False)
			end
		end

end