note
	description: "Aid to development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-11 11:39:40 GMT (Monday 11th July 2016)"
	revision: "8"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			Console.show_all (<< {EL_FTP_PROTOCOL} >>)
		end

feature -- Basic operations

	run
		do
			do_file_data_test (agent ftp_test_set.test_ftp)
		end

feature -- Tests

	audio_command_test_set: AUDIO_COMMAND_TEST_SET
		do
			create Result
		end

	file_command_test_set: FILE_COMMAND_TEST_SET
		do
			create Result
		end

	ftp_test_set: FTP_TEST_SET
		do
			create Result
		end

	os_command_test_set: OS_COMMAND_TEST_SET
		do
			create Result
		end

	storable_test_set: STORABLE_TEST_SET
		do
			create Result
		end

	string_32_routines_test_set: STRING_32_ROUTINES_TEST_SET
		do
			create Result
		end

	text_parser_test_set: TEXT_PARSER_TEST_SET
		do
			create Result
		end

	translation_table_test_set: TRANSLATION_TABLE_TEST_SET
		do
			create Result
		end

	zstring_test_set: ZSTRING_TEST_SET
		do
			create Result
		end

feature {NONE} -- Implementation

	do_file_data_test (test: PROCEDURE [EQA_TEST_SET, TUPLE])
		do
			test.apply
			if attached {EL_FILE_DATA_TEST_SET} test.target as data_test then
				data_test.clean (False)
			end
		end

feature {NONE} -- Constants

	Description: STRING = "Develop AutoTest sets"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines],
				[{TRANSLATION_TABLE_TEST_SET}, All_routines],
				[{FILE_COMMAND_TEST_SET}, All_routines],
				[{OS_COMMAND_TEST_SET}, All_routines],
				[{AUDIO_COMMAND_TEST_SET}, All_routines],
				[{FTP_TEST_SET}, All_routines]
--				[{EL_WAV_TO_MP3_COMMAND_IMP}, All_routines]
--				[{EL_GVFS_OS_COMMAND}, All_routines]
			>>
		end

	Option_name: STRING = "autotest"

end
