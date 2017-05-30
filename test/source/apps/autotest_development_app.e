note
	description: "Aid to development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-27 10:26:05 GMT (Saturday 27th May 2017)"
	revision: "9"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

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
			do_file_data_test (agent path_test_set.test_relative_path)
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

	http_test_set: HTTP_CONNECTION_TEST_SET
		do
			create Result
		end

	os_command_test_set: OS_COMMAND_TEST_SET
		do
			create Result
		end

	path_test_set: EL_PATH_TEST_SET
		do
			create Result
		end

	se_array2_test_set: SE_ARRAY2_TEST_SET
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

	uri_path_test_set: EL_URI_PATH_TEST_SET
		do
			create Result
		end

	zstring_test_set: ZSTRING_TEST_SET
		do
			create Result
		end

feature {NONE} -- Constants

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines],
				[{TRANSLATION_TABLE_TEST_SET}, All_routines],
				[{FILE_COMMAND_TEST_SET}, All_routines],
				[{OS_COMMAND_TEST_SET}, All_routines],
				[{AUDIO_COMMAND_TEST_SET}, All_routines],
				[{FTP_TEST_SET}, All_routines],
				[{HTTP_CONNECTION_TEST_SET}, All_routines]
--				[{SE_ARRAY2_TEST_SET}, All_routines]
--				[{EL_WAV_TO_MP3_COMMAND_IMP}, All_routines]
--				[{EL_GVFS_OS_COMMAND}, All_routines]
			>>
		end

end
