note
	description: "Aid to development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-09 14:43:13 GMT (Monday 9th April 2018)"
	revision: "19"

class
	AUTOTEST_DEVELOPMENT_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION
		rename
			Zstring as Mod_zstring
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
			do_file_data_test (agent comma_separated_import.test_import_export)
		end

feature -- Test sets

	audio_command: AUDIO_COMMAND_TEST_SET
		do
			create Result
		end

	amazon_instant_access: AMAZON_INSTANT_ACCESS_TEST_SET
		do
			create Result
		end

	date_text: DATE_TEXT_TEST_SET
		do
			create Result
		end

	comma_separated_import: COMMA_SEPARATED_IMPORT_TEST_SET
		do
			create Result
		end

	digest: DIGEST_ROUTINES_TEST_SET
		do
			create Result
		end

	file_command: FILE_COMMAND_TEST_SET
		do
			create Result
		end

	ftp: FTP_TEST_SET
		do
			create Result
		end

	http: HTTP_CONNECTION_TEST_SET
		do
			create Result
		end

	json_name_value_list: JSON_NAME_VALUE_LIST_TEST_SET
		do
			create Result
		end

	os_command: OS_COMMAND_TEST_SET
		do
			create Result
		end

	path: EL_PATH_TEST_SET
		do
			create Result
		end

	reflection: REFLECTION_TEST_SET
		do
			create Result
		end

	reflectively_json_settable: REFLECTIVELY_JSON_SETTABLE_TEST_SET
		do
			create Result
		end

	se_array2: SE_ARRAY2_TEST_SET
		do
			create Result
		end

	storable: STORABLE_TEST_SET
		do
			create Result
		end

	string_32_routines: STRING_32_ROUTINES_TEST_SET
		do
			create Result
		end

	substitution_template: SUBSTITUTION_TEMPLATE_TEST_SET
		do
			create Result
		end

	text_parser: TEXT_PARSER_TEST_SET
		do
			create Result
		end

	translation_table: TRANSLATION_TABLE_TEST_SET
		do
			create Result
		end

	dir_uri_path: DIR_URI_PATH_TEST_SET
		do
			create Result
		end

	uri_encoding: URI_ENCODING_TEST_SET
		do
			create Result
		end

	zstring: ZSTRING_TEST_SET
		do
			create Result
		end

feature {NONE} -- Constants

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{AUTOTEST_DEVELOPMENT_APP}, All_routines],
				[{TRANSLATION_TABLE_TEST_SET}, All_routines],
				[{FILE_COMMAND_TEST_SET}, All_routines],
				[{OS_COMMAND_TEST_SET}, All_routines],
				[{AUDIO_COMMAND_TEST_SET}, All_routines],
				[{FTP_TEST_SET}, All_routines],
				[{HTTP_CONNECTION_TEST_SET}, All_routines],
				[{EL_PATH_TEST_SET}, All_routines],
				[{COMMA_SEPARATED_IMPORT_TEST_SET}, All_routines]
			>>
		end

end
