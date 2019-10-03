note
	description: "Test set factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-02 10:45:28 GMT (Wednesday   2nd   October   2019)"
	revision: "3"

class
	TEST_SET_FACTORY

feature -- Test sets

	amazon_instant_access: AMAZON_INSTANT_ACCESS_TEST_SET
		do
			create Result
		end

	audio_command: AUDIO_COMMAND_TEST_SET
		do
			create Result
		end

	chain: CHAIN_TEST_SET
		do
			create Result
		end

	comma_separated_import: COMMA_SEPARATED_IMPORT_TEST_SET
		do
			create Result
		end

	date_text: DATE_TEXT_TEST_SET
		do
			create Result
		end

	digest: DIGEST_ROUTINES_TEST_SET
		do
			create Result
		end

	dir_uri_path: DIR_URI_PATH_TEST_SET
		do
			create Result
		end

	file_command: FILE_COMMAND_TEST_SET
		do
			create Result
		end

	file_tree_input_output_command: FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET
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

	path: PATH_TEST_SET
		do
			create Result
		end

	path_steps: PATH_STEPS_TEST_SET
		do
			create Result
		end

	paypal: PAYPAL_TEST_SET
		do
			create Result
		end

	reflection: REFLECTION_TEST_SET
		do
			create Result
		end

	reflective: REFLECTIVE_TEST_SET
		do
			create Result
		end

	search_engine: SEARCH_ENGINE_TEST_SET
		do
			create Result
		end

	se_array2: SE_ARRAY2_TEST_SET
		do
			create Result
		end

	settable_from_json_string: SETTABLE_FROM_JSON_STRING_TEST_SET
		do
			create Result
		end

	string_32_routines: STRING_32_ROUTINES_TEST_SET
		do
			create Result
		end

	string_edition_history: STRING_EDITION_HISTORY_TEST_SET
		do
			create Result
		end

	string_editor: STRING_EDITOR_TEST_SET
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

	uri_encoding: URI_ENCODING_TEST_SET
		do
			create Result
		end

	zstring: ZSTRING_TEST_SET
		do
			create Result
		end

	zstring_token_table: ZSTRING_TOKEN_TABLE_TEST_SET
		do
			create Result
		end

end
