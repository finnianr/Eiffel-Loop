note
	description: "Summary description for {TEST_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-21 14:33:23 GMT (Thursday 21st January 2016)"
	revision: "8"

class
	TEST_APP

inherit
	EL_SUB_APPLICATION
		rename
			run as test_zstring
		redefine
			Option_name
		end

	EL_MODULE_STRING_8

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	Foot_note_link: ZSTRING
		once
			Result := "[%%#%S]"
		end

	test_hexadecimal_to_natural_64
		do
			log.put_string (String_8.hexadecimal_to_natural_64 ("0x00000982").out)
			log.put_new_line
		end

	test_hash_table_put
		local
			table: HASH_TABLE [INTEGER, STRING_32]
		do
			create table.make_equal (23)

			table.put (table.count + 1,"A")
			table.put (table.count + 1,"A")
			table.put (table.count + 1,"B")

		end

	test_execution_environment_put
		do
			Execution_environment.put ("sausage", "SSL_PW")
			Execution_environment.system ("echo Password: $SSL_PW")
		end

	test_has_repeated_hexadecimal_digit
		do
			log.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAAA)); log.put_new_line
			log.put_boolean (has_repeated_hexadecimal_digit (0x1AAAAAAAAAAAAAAA)); log.put_new_line
			log.put_boolean (has_repeated_hexadecimal_digit (0xAAAAAAAAAAAAAAA1)); log.put_new_line
		end

	test_directory_path
		local
			dir: EL_DIR_PATH; temp: EL_FILE_PATH
		do
			create dir.make_from_latin_1 ("E:/")
			temp := dir + "temp"
			log.put_string_field ("Path", temp.as_windows.to_string)
		end

	test_tuple_to_array
		local
			tuple: ARRAYED_LIST [ANY]
		do
			create tuple.make (2)
			tuple.extend ("hello")
			tuple.extend (1)
			log.enter_with_args ("run_6", tuple.to_array)
			log.exit
		end

	test_parser
		local
			test: TEXT_PARSER_TEST_SET
		do
			log.enter ("test_parser")
			create test
			test.test_recursive_match
			log.exit
		end

	test_procedure_twin
		local
			action, action_2: PROCEDURE [ANY, TUPLE [STRING]]
		do
			action := agent hello_routine
			action_2 := action.twin
			action_2.set_operands (["wonderful"])
			action_2.apply
		end

	test_tuple_setting
		local
			internal: INTERNAL
			color: TUPLE [margins, background: STRING]
		do
			create internal
			create color
			color.margins := "blue"
			color.background := "red"
			log.put_integer_field ("First field", internal.field_count (color))
			log.put_new_line
		end

	test_string_manifest_escaping
		do
			log.put_string ("")
			io.put_string ("%/65/%/27/[128;0;128mB")
		end

	test_string_32_routines
		local
			test_set: STRING_32_ROUTINES_TEST_SET
		do
			log.enter ("test_string_32_routines")
			create test_set
			test_set.test_delimited_list
			log.exit
		end

	test_zstring
		local
			test: ZSTRING_TEST_SET
		do
			log.enter ("test_zstring")
			create test
			test.test_left_adjust
			test.test_right_adjust
			log.exit
		end

	test_storable
		local
			test: STORABLE_TEST_SET
		do
			log.enter ("test_storable")
			create test
			test.test_storable
			log.exit
		end

	test_translation_table
		local
			test: TRANSLATION_TABLE_TEST_SET
		do
			create test
			test.test_reading_from_source
		end

feature -- Tests

	directory_creation (wav_path: EL_DIR_PATH)
			--
		local
			opt_path_steps: EL_PATH_STEPS
			test_dir: EL_DIR_PATH
		do
			log.enter ("directory_creation")
			opt_path_steps := "/opt/program-creation-test"
			if opt_path_steps.is_createable_dir then
				File_system.make_directory (opt_path_steps)
				log.put_string_field ("Path", opt_path_steps.as_directory_path.to_string)
				log.put_string (" created")
				log.put_new_line
			else
				log.put_string_field ("Path", opt_path_steps.as_directory_path.to_string)
				log.put_string (" not creatable")
				log.put_new_line
			end

			test_dir := wav_path.joined_dir_steps (<< "sub1", "sub2", "sub3" >>)
			if test_dir.is_createable then
				File_system.make_directory (test_dir)
				log.put_string_field ("Path", test_dir.to_string)
				log.put_string (" created")
				log.put_new_line
				File_system.copy (wav_path + "pop.wav", test_dir)
			else
				log.put_string_field ("Path", test_dir.to_string)
				log.put_string (" not creatable")
				log.put_new_line
			end

			log.exit
		end

	file_and_directory_creation_with_latin1_chars (dir_path: EL_DIR_PATH)
			--
		local
			file_path: EL_FILE_PATH
		do
			log.enter ("file_and_directory_creation_with_latin1_chars")

			file_path := dir_path + "pop.wav"
			File_system.make_directory (dir_path.joined_dir_path ("Enrique Rodríguez"))
			File_system.move (file_path, dir_path.joined_file_steps (<< "Enrique Rodríguez", "No te Quiero Más.wav" >>))
			log.exit
		end

	hello_routine (a_arg: STRING)
		do
			log.enter_with_args ("hello_routine", << a_arg >>)
			log.exit
		end

feature {NONE} -- Implementation

	has_repeated_hexadecimal_digit (n: NATURAL_64): BOOLEAN
		local
			first, hex_digit: NATURAL_64
			i: INTEGER
		do
			first := n & 0xF
			hex_digit := first
			from i := 1 until hex_digit /= first or i > 15 loop
				hex_digit := n.bit_shift_right (i * 4) & 0xF
				i := i + 1
			end
			Result := i = 16 and then hex_digit = first
		end

feature {NONE} -- Constants

	Description: STRING = "Call manual and automatic sets"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{TEST_APP}, All_routines],
				[{TRANSLATION_TABLE_TEST_SET}, All_routines]
			>>
		end

	Option_name: STRING = "test"

end
